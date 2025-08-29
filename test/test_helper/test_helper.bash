#!/usr/bin/env bash

# Load BATS libraries từ node_modules  
load '../node_modules/bats-support/load.bash'
load '../node_modules/bats-assert/load.bash'

# Setup test environment
setup_test_environment() {
    export TEST_TEMP_DIR="$(mktemp -d)"
    export PATH="$BATS_TEST_DIRNAME/../scripts:$PATH"
    
    # Mock commands directory
    export PATH="$TEST_TEMP_DIR/mocks:$PATH"  
    mkdir -p "$TEST_TEMP_DIR/mocks"
    
    # Save original directory
    export ORIGINAL_PWD="$PWD"
}

teardown_test_environment() {
    [[ -d "$TEST_TEMP_DIR" ]] && rm -rf "$TEST_TEMP_DIR"
    cd "$ORIGINAL_PWD" || return 1
}

create_mock_command() {
    local cmd="$1"
    local response="$2"
    local exit_code="${3:-0}"
    
    cat > "$TEST_TEMP_DIR/mocks/$cmd" << EOF
#!/bin/bash
echo "$response"
exit $exit_code
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/$cmd"
}

# Create a mock that logs its arguments for verification
create_mock_command_with_args() {
    local cmd="$1"
    local response="$2"
    local exit_code="${3:-0}"
    
    cat > "$TEST_TEMP_DIR/mocks/$cmd" << EOF
#!/bin/bash
echo "\$@" >> "$TEST_TEMP_DIR/mock_calls_$cmd"
echo "$response"
exit $exit_code
EOF
    chmod +x "$TEST_TEMP_DIR/mocks/$cmd"
}

# Verify that a mock command was called with specific arguments
assert_mock_called_with() {
    local cmd="$1"
    local expected_args="$2"
    local call_file="$TEST_TEMP_DIR/mock_calls_$cmd"
    
    if [[ ! -f "$call_file" ]]; then
        fail "Command '$cmd' was never called"
    fi
    
    if ! grep -F "$expected_args" "$call_file"; then
        fail "Command '$cmd' was not called with expected arguments: '$expected_args'"
    fi
}

# Mock git commands commonly used in scripts
mock_git_success() {
    local commit_message="${1:-feat(test): add test functionality}"
    create_mock_command "git" "$commit_message"
}

mock_git_failure() {
    create_mock_command "git" "error: bad commit message" 1
}

# Mock fvm commands
mock_fvm_success() {
    create_mock_command "fvm" ""
}

mock_fvm_failure() {
    create_mock_command "fvm" "error: fvm command failed" 1
}

# Mock npm commands
mock_npm_success() {
    create_mock_command "npm" ""
    create_mock_command "npx" ""
}

mock_npm_failure() {
    create_mock_command "npm" "error: npm command failed" 1
    create_mock_command "npx" "error: npx command failed" 1
}

# Debug helpers for better developer experience
debug_test() {
    [[ "$BATS_DEBUG" == "1" ]] && echo "DEBUG: $*" >&2
}

debug_mock_calls() {
    local cmd="$1"
    local call_file="$TEST_TEMP_DIR/mock_calls_$cmd"
    if [[ -f "$call_file" ]]; then
        echo "DEBUG: Mock calls for '$cmd':" >&2
        cat "$call_file" | sed 's/^/  /' >&2
    else
        echo "DEBUG: No mock calls recorded for '$cmd'" >&2
    fi
}

debug_test_env() {
    echo "DEBUG: Test environment:" >&2
    echo "  TEST_TEMP_DIR: $TEST_TEMP_DIR" >&2
    echo "  PATH: $PATH" >&2
    echo "  PWD: $PWD" >&2
    echo "  Mock commands available:" >&2
    ls -la "$TEST_TEMP_DIR/mocks/" 2>/dev/null | sed 's/^/    /' >&2 || echo "    No mocks found" >&2
}

# Performance testing helpers
time_test() {
    local start_time=$(date +%s%N)
    "$@"
    local end_time=$(date +%s%N)
    local duration=$((($end_time - $start_time) / 1000000))
    echo "DEBUG: Test took ${duration}ms" >&2
}

# File assertion helpers
assert_file_exists() {
    local file="$1"
    [[ -f "$file" ]] || fail "File does not exist: $file"
}

assert_file_not_exists() {
    local file="$1"
    [[ ! -f "$file" ]] || fail "File should not exist: $file"
}

assert_file_contains() {
    local file="$1"
    local pattern="$2"
    [[ -f "$file" ]] || fail "File does not exist: $file"
    grep -q "$pattern" "$file" || fail "File '$file' does not contain: $pattern"
}

# Memory testing helpers
check_memory_usage() {
    if command -v ps >/dev/null 2>&1; then
        local memory=$(ps -o rss= -p $$ | tr -d ' ')
        echo "DEBUG: Current memory usage: ${memory}KB" >&2
    fi
}

# Cleanup helpers
cleanup_temp_files() {
    # Clean up any leftover temp files from failed tests
    find /tmp -name "license-cache*" -type d -exec rm -rf {} + 2>/dev/null || true
    find /tmp -name "bats-*" -type d -exec rm -rf {} + 2>/dev/null || true
}
