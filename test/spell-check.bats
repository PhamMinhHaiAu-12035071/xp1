#!/usr/bin/env bats

load 'test_helper/test_helper'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "spell-check should pass when all steps succeed" {
    # Arrange
    mock_npm_success
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/spell-check.sh"
    
    # Assert
    assert_success
    assert_output --partial "📝 Running spell check..."
    assert_output --partial "✅ Spell check passed"
}

@test "spell-check should fail when npm list fails and install fails" {
    # Arrange
    create_mock_command_with_args "npm" ""
    cat > "$TEST_TEMP_DIR/mocks/npm" << 'EOF'
#!/bin/bash
if [[ "$*" == *"list cspell"* ]]; then
    echo "Error: cspell not found"
    exit 1
elif [[ "$*" == *"install cspell"* ]]; then
    echo "Error: Could not install cspell"
    exit 1
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/npm"
    create_mock_command "npx" ""
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/spell-check.sh"
    
    # Assert
    assert_failure
    assert_output --partial "📦 Installing cspell if needed..."
}

@test "spell-check should auto-install cspell when not found" {
    # Arrange
    create_mock_command_with_args "npm" ""
    cat > "$TEST_TEMP_DIR/mocks/npm" << 'EOF'
#!/bin/bash
if [[ "$*" == *"list cspell"* ]]; then
    echo "Error: cspell not found"
    exit 1
elif [[ "$*" == *"install cspell"* ]]; then
    echo "Installing cspell..."
    exit 0
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/npm"
    mock_npm_success
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/spell-check.sh"
    
    # Assert
    assert_success
    assert_output --partial "📦 Installing cspell if needed..."
}

@test "spell-check should fail when markdown spell check fails" {
    # Arrange
    mock_npm_success
    create_mock_command_with_args "npx" ""
    cat > "$TEST_TEMP_DIR/mocks/npx" << 'EOF'
#!/bin/bash
if [[ "$*" == *'**/*.md'* ]]; then
    echo "Error: Spelling errors found in markdown files"
    exit 1
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/npx"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/spell-check.sh"
    
    # Assert
    assert_failure
    assert_output --partial "📚 Checking markdown files..."
}

@test "spell-check should fail when dart spell check fails" {
    # Arrange
    mock_npm_success
    create_mock_command_with_args "npx" ""
    cat > "$TEST_TEMP_DIR/mocks/npx" << 'EOF'
#!/bin/bash
if [[ "$*" == *'lib/**/*.dart'* ]] || [[ "$*" == *'test/**/*.dart'* ]]; then
    echo "Error: Spelling errors found in Dart files"
    exit 1
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/npx"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/spell-check.sh"
    
    # Assert
    assert_failure
    assert_output --partial "📝 Checking Dart code documentation..."
}

@test "spell-check should display all expected status messages" {
    # Arrange
    mock_npm_success
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/spell-check.sh"
    
    # Assert
    assert_success
    assert_output --partial "📝 Running spell check..."
    assert_output --partial "📦 Installing cspell if needed..."
    assert_output --partial "📚 Checking markdown files..."
    assert_output --partial "📝 Checking Dart code documentation..."
    assert_output --partial "✅ Spell check passed"
}

@test "spell-check should call npm and npx commands with correct arguments" {
    # Arrange
    # Mock npm to succeed on list cspell check (so no install needed)
    create_mock_command_with_args "npm" "cspell@8.0.0"
    create_mock_command_with_args "npx" ""
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/spell-check.sh"
    
    # Assert
    assert_success
    assert_mock_called_with "npm" "list cspell"
    assert_mock_called_with "npx" 'cspell **/*.md --no-progress --config cspell.json'
    assert_mock_called_with "npx" 'cspell lib/**/*.dart test/**/*.dart --no-progress --config cspell.json'
}

@test "spell-check should handle cspell already installed scenario" {
    # Arrange
    create_mock_command_with_args "npm" ""
    cat > "$TEST_TEMP_DIR/mocks/npm" << 'EOF'
#!/bin/bash
if [[ "$*" == *"list cspell"* ]]; then
    echo "cspell@8.0.0"
    exit 0
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/npm"
    mock_npm_success
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/spell-check.sh"
    
    # Assert
    assert_success
    assert_output --partial "📦 Installing cspell if needed..."
    # Should not try to install cspell again
    refute_output --partial "install cspell"
}
