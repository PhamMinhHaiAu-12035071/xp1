#!/usr/bin/env bats

load 'test_helper/test_helper'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

# TDD RED PHASE: These tests should initially fail to ensure proper TDD

@test "semantic-check should pass with valid conventional commit" {
    # Arrange
    mock_git_success "feat(auth): add user login functionality"
    mock_fvm_success
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/semantic-check.sh"
    
    # Assert
    assert_success
    assert_output --partial "✅ Semantic checks passed"
    assert_output --partial "🔍 Running semantic checks..."
}

@test "semantic-check should fail with invalid commit message" {
    # Arrange  
    mock_git_success "random commit message without format"
    create_mock_command "fvm" "error: invalid commit format" 1
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/semantic-check.sh"
    
    # Assert
    assert_failure
    assert_output --partial "🔍 Running semantic checks..."
}

@test "semantic-check should fail when dart commit validation fails" {
    # Arrange
    mock_git_success "feat(test): valid conventional commit"
    create_mock_command "fvm" "Commit message validation failed" 1
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/semantic-check.sh"
    
    # Assert
    assert_failure
    assert_output --partial "📝 Validating commit message..."
}

@test "semantic-check should fail when PR title validation fails" {
    # Arrange
    mock_git_success "feat(test): valid conventional commit" 
    # First fvm call (commit validation) succeeds
    create_mock_command_with_args "fvm" ""
    # Create a separate mock for the second fvm call that fails
    cat > "$TEST_TEMP_DIR/mocks/fvm" << 'EOF'
#!/bin/bash
if [[ "$*" == *"validate_pr_title"* ]]; then
    echo "PR title validation failed"
    exit 1
fi
echo ""
exit 0
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/fvm"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/semantic-check.sh"
    
    # Assert
    assert_failure
    assert_output --partial "🏷️  Validating PR title..."
}

@test "semantic-check should display all expected status messages" {
    # Arrange
    mock_git_success "feat(test): comprehensive test message"
    mock_fvm_success
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/semantic-check.sh"
    
    # Assert
    assert_success
    assert_output --partial "🔍 Running semantic checks..."
    assert_output --partial "📝 Validating commit message..."
    assert_output --partial "🏷️  Validating PR title..."
    assert_output --partial "✅ Semantic checks passed"
}

@test "semantic-check should call validation tools with correct arguments" {
    # Arrange
    mock_git_success "docs(readme): update installation guide"
    create_mock_command_with_args "fvm" ""
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/semantic-check.sh"
    
    # Assert
    assert_success
    assert_mock_called_with "fvm" "dart run tool/validate_commit.dart"
    assert_mock_called_with "fvm" "dart run tool/validate_pr_title.dart"
}
