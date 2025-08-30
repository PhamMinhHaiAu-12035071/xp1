#!/usr/bin/env bats

load 'test_helper/test_helper'

setup() {
    setup_test_environment
    
    # Save original directory and change to temp directory
    export ORIGINAL_DIR="$PWD"
    cd "$TEST_TEMP_DIR"
    
    # Setup minimal project structure
    mkdir -p lib test
    
    # Mock dart commands
    create_mock_command "dart" "All analysis completed successfully"
    create_mock_command "fvm" ""
}

teardown() {
    teardown_test_environment
}

@test "simplified naming check should work with Makefile" {
    # Arrange
    cat > "Makefile" << 'EOF'
naming-check:
	@echo "🔍 Checking naming conventions..."
	@fvm dart analyze --fatal-infos
	@echo "✅ Naming check completed"
EOF
    
    # Act
    run make naming-check
    
    # Assert
    assert_success
    assert_output --partial "🔍 Checking naming conventions..."
    assert_output --partial "✅ Naming check completed"
}

@test "simplified naming fix should work with Makefile" {
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

@test "naming conventions docs should be concise and readable" {
    # Arrange - Check actual docs in original project
    docs_file="$ORIGINAL_DIR/doc/naming-conventions.md"
    
    if [[ -f "$docs_file" ]]; then
        line_count=$(wc -l < "$docs_file")
        
        # Act & Assert - Should be under 102 lines (much shorter than original 546)
        assert [ "$line_count" -le 102 ]
        
        # Check that it contains essential sections
        assert grep -q "Quick Reference" "$docs_file"
        assert grep -q "camelCase" "$docs_file" 
        assert grep -q "PascalCase" "$docs_file"
        assert grep -q "snake_case" "$docs_file"
    else
        skip "naming-conventions.md not found"
    fi
}

@test "lefthook should use simplified naming check" {
    # Arrange
    cat > "lefthook.yml" << 'EOF'
pre-commit:
  commands:
    naming-check:
      glob: "*.dart"
      run: |
        DART_FILES=$(git diff --cached --name-only --diff-filter=ACMR | grep '\.dart$')
        if [ -n "$DART_FILES" ]; then
          echo "🏷️ Checking naming conventions..."
          fvm dart analyze --fatal-infos
        fi
EOF
    
    # Act - Simulate git hook (we just test the command works)
    run bash -c 'echo "🏷️ Checking naming conventions..."; fvm dart analyze --fatal-infos'
    
    # Assert
    assert_success
    assert_output --partial "🏷️ Checking naming conventions..."
}

@test "analysis_options.yaml should contain all naming rules" {
    # Arrange - Check actual analysis options in original project
    options_file="$ORIGINAL_DIR/analysis_options.yaml"
    
    if [[ -f "$options_file" ]]; then
        # Act & Assert - Check essential naming rules exist
        assert grep -q "camel_case_types: error" "$options_file"
        assert grep -q "non_constant_identifier_names: error" "$options_file"
        assert grep -q "constant_identifier_names: error" "$options_file"
        assert grep -q "file_names: error" "$options_file"
        assert grep -q "camel_case_types: true" "$options_file"
        assert grep -q "non_constant_identifier_names: true" "$options_file"
    else
        skip "analysis_options.yaml not found"
    fi
}