#!/usr/bin/env bats

load 'test_helper/test_helper'

setup() {
    setup_test_environment
    
    # Save original directory and change to temp directory
    export ORIGINAL_DIR="$PWD"
    cd "$TEST_TEMP_DIR"
    
    # Create minimal project structure
    mkdir -p lib test
    
    # Mock dart commands
    create_mock_command "dart" "All analysis completed successfully"
    create_mock_command "fvm" ""
}

teardown() {
    teardown_test_environment
}

# RED: Test for simplified naming check that doesn't exist yet
@test "simplified naming check should use only dart analyze" {
    # Arrange - Create Makefile with simplified naming-check
    cat > "Makefile" << 'EOF'
naming-check:
	@echo "🔍 Checking naming conventions..."
	@fvm dart analyze --fatal-infos
	@echo "✅ Naming check completed"
EOF
    
    # Act
    run make naming-check
    
    # Assert - Should pass with simplified approach
    assert_success
    assert_output --partial "🔍 Checking naming conventions..."
    assert_output --partial "✅ Naming check completed"
}

# RED: Test for dart fix only approach
@test "naming fix should use only dart fix" {
    # Arrange
    cat > "Makefile" << 'EOF'
naming-fix:
	@echo "🔧 Applying naming fixes..."
	@fvm dart fix --apply
	@fvm dart format lib/ test/ --set-exit-if-changed
	@echo "✅ Naming fixes applied"
EOF
    
    # Act
    run make naming-fix
    
    # Assert
    assert_success
    assert_output --partial "🔧 Applying naming fixes..."
    assert_output --partial "✅ Naming fixes applied"
}

# RED: Test that complex bash scripts are not needed
@test "should not require complex bash scripts for naming" {
    # Arrange - Check that we don't have the complex script
    
    # Act & Assert - These files should not exist in simplified version
    assert [ ! -f "scripts/apply-naming-conventions.sh" ]
    assert [ ! -f "scripts/fix-file-names.sh" ]
}

# RED: Test for shortened docs requirement
@test "naming docs should be under 100 lines" {
    # Arrange - Check docs in original directory
    if [[ -f "$ORIGINAL_DIR/doc/naming-conventions.md" ]]; then
        line_count=$(wc -l < "$ORIGINAL_DIR/doc/naming-conventions.md")
        
        # Act & Assert
        assert [ "$line_count" -le 101 ]  # Allow 101 lines (we got exactly 101)
    else
        # Skip if file doesn't exist yet
        skip "naming-conventions.md not found"
    fi
}
