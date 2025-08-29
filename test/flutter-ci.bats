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
    # Arrange
    create_mock_command_with_args "fvm" ""
    cat > "$TEST_TEMP_DIR/mocks/fvm" << 'EOF'
#!/bin/bash
if [[ "$*" == *"flutter test"* ]]; then
    echo "Error: Tests failed"
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

@test "flutter-ci should call fvm commands with correct arguments" {
    # Arrange
    create_mock_command_with_args "fvm" ""
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/flutter-ci.sh"
    
    # Assert
    assert_success
    assert_mock_called_with "fvm" "flutter pub get"
    assert_mock_called_with "fvm" "flutter analyze --fatal-infos"
    assert_mock_called_with "fvm" "dart format lib/ test/ --set-exit-if-changed --output=none"
    assert_mock_called_with "fvm" "flutter test"
    assert_mock_called_with "fvm" "flutter pub publish --dry-run"
}
