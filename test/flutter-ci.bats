#!/usr/bin/env bats

load 'test_helper/test_helper'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "flutter-ci should pass when all steps succeed" {
    # Arrange
    mock_fvm_success
    create_mock_command "make" ""
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/flutter-ci.sh"
    
    # Assert
    assert_success
    assert_output --partial "🚀 Running Flutter CI..."
    assert_output --partial "✅ Flutter CI passed"
}

@test "flutter-ci should fail when pub get fails" {
    # Arrange
    create_mock_command_with_args "fvm" ""
    cat > "$TEST_TEMP_DIR/mocks/fvm" << 'EOF'
#!/bin/bash
if [[ "$*" == *"pub get"* ]]; then
    echo "Error: Could not get dependencies"
    exit 1
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/fvm"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/flutter-ci.sh"
    
    # Assert
    assert_failure
    assert_output --partial "📦 Installing dependencies..."
}

@test "flutter-ci should fail when analyze fails" {
    # Arrange
    create_mock_command_with_args "fvm" ""
    cat > "$TEST_TEMP_DIR/mocks/fvm" << 'EOF'
#!/bin/bash
if [[ "$*" == *"analyze"* ]]; then
    echo "Error: Analysis failed"
    exit 1
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/fvm"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/flutter-ci.sh"
    
    # Assert
    assert_failure
    assert_output --partial "🔍 Analyzing code..."
}

@test "flutter-ci should fail when format check fails" {
    # Arrange
    create_mock_command_with_args "fvm" ""
    cat > "$TEST_TEMP_DIR/mocks/fvm" << 'EOF'
#!/bin/bash
if [[ "$*" == *"format"* ]]; then
    echo "Error: Code is not formatted"
    exit 1
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/fvm"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/flutter-ci.sh"
    
    # Assert
    assert_failure
    assert_output --partial "🎨 Checking code format..."
}

@test "flutter-ci should fail when tests fail" {
    # Arrange - Mock both fvm (for other commands) and make (for test command)
    create_mock_command_with_args "fvm" ""
    create_mock_command_with_args "make" ""
    cat > "$TEST_TEMP_DIR/mocks/make" << 'EOF'
#!/bin/bash
if [[ "$*" == *"test"* ]]; then
    echo "Error: Tests failed"
    exit 1
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/make"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/flutter-ci.sh"
    
    # Assert
    assert_failure
    assert_output --partial "🧪 Running tests..."
}

@test "flutter-ci should fail when publish dry-run fails" {
    # Arrange
    create_mock_command_with_args "fvm" ""
    cat > "$TEST_TEMP_DIR/mocks/fvm" << 'EOF'
#!/bin/bash
if [[ "$*" == *"publish --dry-run"* ]]; then
    echo "Error: Package is not ready for publishing"
    exit 1
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/fvm"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/flutter-ci.sh"
    
    # Assert
    assert_failure
    assert_output --partial "📋 Checking publish readiness..."
}

@test "flutter-ci should display all expected status messages" {
    # Arrange
    mock_fvm_success
    create_mock_command "make" ""
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/flutter-ci.sh"
    
    # Assert
    assert_success
    assert_output --partial "🚀 Running Flutter CI..."
    assert_output --partial "📦 Installing dependencies..."
    assert_output --partial "🔍 Analyzing code..."
    assert_output --partial "🎨 Checking code format..."
    assert_output --partial "🧪 Running tests..."
    assert_output --partial "📋 Checking publish readiness..."
    assert_output --partial "✅ Flutter CI passed"
}

@test "flutter-ci should call fvm and make commands with correct arguments" {
    # Arrange
    create_mock_command_with_args "fvm" ""
    create_mock_command_with_args "make" ""
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/flutter-ci.sh"
    
    # Assert
    assert_success
    assert_mock_called_with "fvm" "flutter pub get"
    assert_mock_called_with "fvm" "flutter analyze --fatal-infos"
    # Check that find command is called for excluding generated files
    [[ "$output" =~ "find lib -name" ]]
    # Check that test directory formatting is still called normally
    assert_mock_called_with "fvm" "dart format test/ --set-exit-if-changed --output=none"
    assert_mock_called_with "make" "test"
    assert_mock_called_with "fvm" "flutter pub publish --dry-run"
}
