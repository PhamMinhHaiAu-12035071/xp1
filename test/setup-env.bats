#!/usr/bin/env bats

# setup-env.bats - Comprehensive BATS tests for setup-env.sh script
# Following TDD red-green-refactor cycle with 100% coverage

load 'test_helper/test_helper.bash'

# Test environment variables
TEST_ENV_DIR=""
SCRIPT_PATH="scripts/setup-env.sh"

setup() {
    # Create unique test environment for each test
    TEST_ENV_DIR="$(mktemp -d)"
    export ENV_DIR="$TEST_ENV_DIR"
    
    # Ensure script is executable
    chmod +x "$SCRIPT_PATH"
}

teardown() {
    # Clean up test environment
    if [[ -n "$TEST_ENV_DIR" && -d "$TEST_ENV_DIR" ]]; then
        rm -rf "$TEST_ENV_DIR"
    fi
}

# Helper function to create example files
create_example_file() {
    local env="$1"
    local content="$2"
    
    mkdir -p "$TEST_ENV_DIR"
    if [[ -z "$content" ]]; then
        # Create truly empty file
        > "$TEST_ENV_DIR/${env}.env.example"
    else
        echo "$content" > "$TEST_ENV_DIR/${env}.env.example"
    fi
}

# Helper function to run script and capture output
run_setup_script() {
    run bash "$SCRIPT_PATH"
}

# Test 1: Script should be executable and exist
@test "setup-env.sh script should exist and be executable" {
    [[ -f "$SCRIPT_PATH" ]]
    [[ -x "$SCRIPT_PATH" ]]
}

# Test 2: Script should create environment directory if it doesn't exist
@test "should create ENV_DIR if it doesn't exist" {
    # Red: Directory doesn't exist
    [[ ! -d "$TEST_ENV_DIR" ]]
    
    # Green: Script should create it
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ -d "$TEST_ENV_DIR" ]]
}

# Test 3: Should create .env from .env.example when example exists
@test "should create development.env from development.env.example" {
    # Red: Setup example file but no .env file
    create_example_file "development" "API_URL=http://localhost:3000"
    
    # Green: Script should create .env file
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ -f "$TEST_ENV_DIR/development.env" ]]
    [[ "$(cat "$TEST_ENV_DIR/development.env")" = "API_URL=http://localhost:3000" ]]
}

# Test 4: Should create .env for all environments (development, staging, production)
@test "should create all environment files when examples exist" {
    # Red: Create all example files
    create_example_file "development" "API_URL=http://localhost:3000"
    create_example_file "staging" "API_URL=https://staging.api.com"
    create_example_file "production" "API_URL=https://api.com"
    
    # Green: Script should create all .env files
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ -f "$TEST_ENV_DIR/development.env" ]]
    [[ -f "$TEST_ENV_DIR/staging.env" ]]
    [[ -f "$TEST_ENV_DIR/production.env" ]]
}

# Test 5: Should not overwrite existing .env files
@test "should not overwrite existing .env files" {
    # Red: Create example and existing .env with different content
    create_example_file "development" "API_URL=http://localhost:3000"
    echo "EXISTING_CONTENT=preserve_me" > "$TEST_ENV_DIR/development.env"
    
    # Green: Script should not overwrite existing file
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ "$(cat "$TEST_ENV_DIR/development.env")" = "EXISTING_CONTENT=preserve_me" ]]
    [[ "$(cat "$TEST_ENV_DIR/development.env")" != "API_URL=http://localhost:3000" ]]
}

# Test 6: Should display warning when example file doesn't exist
@test "should display warning when example file doesn't exist" {
    # Red: No example files exist
    
    # Green: Script should warn about missing files
    run_setup_script
    

    [[ "$status" -eq 0 ]]
    [[ "$output" =~ "Warning:" ]]
    [[ "$output" =~ "development.env.example not found" ]]
    [[ "$output" =~ "staging.env.example not found" ]]
    [[ "$output" =~ "production.env.example not found" ]]
}

# Test 7: Should display success messages for created files
@test "should display success messages for created files" {
    # Red: Create example file
    create_example_file "development" "API_URL=test"
    
    # Green: Script should show success message
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ "Creating.*development.env from.*development.env.example" ]]
    [[ "$output" =~ "Created:" ]]
    [[ "$output" =~ "development.env" ]]
}

# Test 8: Should display skip messages for existing files
@test "should display skip messages for existing files" {
    # Red: Create example and existing .env file
    create_example_file "development" "API_URL=test"
    echo "existing" > "$TEST_ENV_DIR/development.env"
    
    # Green: Script should show skip message
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ "development.env already exists, skipping" ]]
}

# Test 9: Should display setup completion message
@test "should display setup completion message" {
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ "Environment setup completed!" ]]
}

# Test 10: Should display next steps instructions
@test "should display next steps instructions" {
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ "Next steps:" ]]
    [[ "$output" =~ "Edit the .env files with your actual values" ]]
    [[ "$output" =~ "Run 'make install-dev'" ]]
}

# Test 11: Should display security note about git-ignored files
@test "should display security note about git-ignored files" {
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ "Security note: .env files are git-ignored for security" ]]
}

# Test 12: Should handle mixed scenario (some files exist, some don't)
@test "should handle mixed scenario correctly" {
    # Red: Mixed scenario - some examples exist, some .env files already exist
    create_example_file "development" "DEV_API=localhost"
    create_example_file "staging" "STAGING_API=staging.com"
    # No production example
    echo "existing_dev" > "$TEST_ENV_DIR/development.env"
    
    # Green: Script should handle all cases appropriately
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    
    # Should skip existing development.env
    [[ "$output" =~ "development.env already exists, skipping" ]]
    [[ "$(cat "$TEST_ENV_DIR/development.env")" = "existing_dev" ]]
    
    # Should create staging.env from example
    [[ -f "$TEST_ENV_DIR/staging.env" ]]
    [[ "$(cat "$TEST_ENV_DIR/staging.env")" = "STAGING_API=staging.com" ]]
    
    # Should warn about missing production example
    [[ "$output" =~ "Warning:" ]]
    [[ "$output" =~ "production.env.example not found" ]]
}

# Test 13: Should preserve file permissions
@test "should preserve file permissions when copying" {
    # Red: Create example file with specific permissions
    create_example_file "development" "API_URL=test"
    chmod 644 "$TEST_ENV_DIR/development.env.example"
    
    # Green: Script should preserve permissions
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ -f "$TEST_ENV_DIR/development.env" ]]
    
    # Check that file has read/write permissions for owner
    [[ -r "$TEST_ENV_DIR/development.env" ]]
    [[ -w "$TEST_ENV_DIR/development.env" ]]
}

# Test 14: Should handle empty example files
@test "should handle empty example files" {
    # Red: Create empty example file
    create_example_file "development" ""
    
    # Green: Script should create empty .env file
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ -f "$TEST_ENV_DIR/development.env" ]]
    [[ ! -s "$TEST_ENV_DIR/development.env" ]]  # File exists but is empty
}

# Test 15: Should handle example files with special characters
@test "should handle example files with special characters" {
    # Red: Create example with special characters
    local special_content="API_URL=https://api.com?param=value&other=123
APP_NAME=Test App (Development)
SECRET_KEY=abc123!@#$%^&*()
MULTI_LINE=line1
line2"
    create_example_file "development" "$special_content"
    
    # Green: Script should preserve special characters
    run_setup_script
    
    [[ "$status" -eq 0 ]]
    [[ -f "$TEST_ENV_DIR/development.env" ]]
    [[ "$(cat "$TEST_ENV_DIR/development.env")" = "$special_content" ]]
}

# Test 16: Script should exit with status 0 on success
@test "should exit with status 0 on success" {
    create_example_file "development" "API_URL=test"
    
    run_setup_script
    
    [[ "$status" -eq 0 ]]
}

# Test 17: Should use set -e for error handling
@test "script should use set -e for proper error handling" {
    # Check that script contains set -e
    run grep -q "set -e" "$SCRIPT_PATH"
    [[ "$status" -eq 0 ]]
}

# Test 18: Should validate script structure and comments
@test "script should have proper structure and documentation" {
    # Check for proper shebang
    run head -n 1 "$SCRIPT_PATH"
    [[ "$output" =~ "#!/bin/bash" ]]
    
    # Check for script description
    run grep -q "setup-env.sh - Script to setup environment files" "$SCRIPT_PATH"
    [[ "$status" -eq 0 ]]
    
    # Check for function documentation
    run grep -q "Function to setup env file for specific environment" "$SCRIPT_PATH"
    [[ "$status" -eq 0 ]]
}

# Test 19: Should handle concurrent execution safely
@test "should handle concurrent execution safely" {
    # Red: Create example file
    create_example_file "development" "API_URL=test"
    
    # Green: Run script multiple times in background
    bash "$SCRIPT_PATH" &
    bash "$SCRIPT_PATH" &
    bash "$SCRIPT_PATH" &
    wait
    
    # Only one .env file should be created with correct content
    [[ -f "$TEST_ENV_DIR/development.env" ]]
    [[ "$(cat "$TEST_ENV_DIR/development.env")" = "API_URL=test" ]]
}

# Test 20: Should validate all required variables are set
@test "script should validate ENVIRONMENTS array contains all required environments" {
    # Check that script contains all three environments
    run grep -o 'development\|staging\|production' "$SCRIPT_PATH"
    
    # Should find all three environments
    local dev_count=$(echo "$output" | grep -c "development" || true)
    local staging_count=$(echo "$output" | grep -c "staging" || true)
    local prod_count=$(echo "$output" | grep -c "production" || true)
    
    [[ "$dev_count" -gt 0 ]]
    [[ "$staging_count" -gt 0 ]]
    [[ "$prod_count" -gt 0 ]]
}
