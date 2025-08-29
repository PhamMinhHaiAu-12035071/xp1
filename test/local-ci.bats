#!/usr/bin/env bats

load 'test_helper/test_helper'

setup() {
    setup_test_environment
    
    # Save original directory and change to temp directory
    export ORIGINAL_DIR="$PWD"
    cd "$TEST_TEMP_DIR"
    
    # Setup scripts directory structure exactly as local-ci expects
    mkdir -p scripts
    
    # Create mock scripts that local-ci.sh calls
    cat > "scripts/semantic-check.sh" << 'EOF'
#!/bin/bash
echo "✅ Semantic checks passed"
exit 0
EOF
    
    cat > "scripts/flutter-ci.sh" << 'EOF'
#!/bin/bash
echo "✅ Flutter CI passed"
exit 0
EOF
    
    cat > "scripts/spell-check.sh" << 'EOF'
#!/bin/bash
echo "✅ Spell check passed"
exit 0
EOF
    
    chmod +x scripts/*.sh
}

teardown() {
    teardown_test_environment
}

@test "local-ci should pass when all sub-scripts succeed" {
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/local-ci.sh"
    
    # Assert
    assert_success
    assert_output --partial "🔥 Running complete local CI pipeline..."
    assert_output --partial "🎉 All CI checks passed! Ready for GitHub Actions!"
}

@test "local-ci should fail when semantic-check fails" {
    # Arrange
    cat > "scripts/semantic-check.sh" << 'EOF'
#!/bin/bash
echo "❌ Semantic checks failed"
exit 1
EOF
    chmod +x "scripts/semantic-check.sh"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/local-ci.sh"
    
    # Assert
    assert_failure
    assert_output --partial "Step 1/3: Semantic checks"
}

@test "local-ci should fail when flutter-ci fails" {
    # Arrange
    cat > "scripts/flutter-ci.sh" << 'EOF'
#!/bin/bash
echo "❌ Flutter CI failed"
exit 1
EOF
    chmod +x "scripts/flutter-ci.sh"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/local-ci.sh"
    
    # Assert
    assert_failure
    assert_output --partial "Step 2/3: Flutter CI"
}

@test "local-ci should fail when spell-check fails" {
    # Arrange
    cat > "scripts/spell-check.sh" << 'EOF'
#!/bin/bash
echo "❌ Spell check failed"
exit 1
EOF
    chmod +x "scripts/spell-check.sh"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/local-ci.sh"
    
    # Assert
    assert_failure
    assert_output --partial "Step 3/3: Spell check"
}

@test "local-ci should display all expected sections and messages" {
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/local-ci.sh"
    
    # Assert
    assert_success
    assert_output --partial "🔥 Running complete local CI pipeline..."
    assert_output --partial "Step 1/3: Semantic checks"
    assert_output --partial "Step 2/3: Flutter CI"
    assert_output --partial "Step 3/3: Spell check"
    assert_output --partial "🎉 All CI checks passed! Ready for GitHub Actions!"
}

@test "local-ci should call scripts in correct order" {
    # Arrange - Add logging to scripts to verify order
    cat > "scripts/semantic-check.sh" << EOF
#!/bin/bash
echo "SEMANTIC_CHECK_CALLED" >> "$TEST_TEMP_DIR/call_order"
echo "✅ Semantic checks passed"
exit 0
EOF
    
    cat > "scripts/flutter-ci.sh" << EOF
#!/bin/bash
echo "FLUTTER_CI_CALLED" >> "$TEST_TEMP_DIR/call_order"
echo "✅ Flutter CI passed"
exit 0
EOF
    
    cat > "scripts/spell-check.sh" << EOF
#!/bin/bash
echo "SPELL_CHECK_CALLED" >> "$TEST_TEMP_DIR/call_order"
echo "✅ Spell check passed"
exit 0
EOF
    
    chmod +x scripts/*.sh
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/local-ci.sh"
    
    # Assert
    assert_success
    [[ -f "$TEST_TEMP_DIR/call_order" ]]
    
    local expected_order="SEMANTIC_CHECK_CALLED
FLUTTER_CI_CALLED
SPELL_CHECK_CALLED"
    
    local actual_order=$(cat "$TEST_TEMP_DIR/call_order")
    [[ "$actual_order" == "$expected_order" ]]
}

@test "local-ci should stop on first failure (fail-fast)" {
    # Arrange - Make semantic-check fail early
    cat > "scripts/semantic-check.sh" << EOF
#!/bin/bash
echo "SEMANTIC_CHECK_CALLED" >> "$TEST_TEMP_DIR/call_order"
echo "❌ Semantic checks failed"
exit 1
EOF
    
    cat > "scripts/flutter-ci.sh" << EOF
#!/bin/bash
echo "FLUTTER_CI_CALLED" >> "$TEST_TEMP_DIR/call_order"
echo "✅ Flutter CI passed"
exit 0
EOF
    
    chmod +x scripts/*.sh
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/local-ci.sh"
    
    # Assert
    assert_failure
    [[ -f "$TEST_TEMP_DIR/call_order" ]]
    
    # Should only have semantic check, not flutter-ci
    local actual_calls=$(cat "$TEST_TEMP_DIR/call_order")
    [[ "$actual_calls" == "SEMANTIC_CHECK_CALLED" ]]
}

@test "local-ci should handle missing scripts gracefully" {
    # Arrange - Remove one script to test error handling
    rm -f "scripts/semantic-check.sh"
    
    # Act
    run bash "$BATS_TEST_DIRNAME/../scripts/local-ci.sh"
    
    # Assert
    assert_failure
}
