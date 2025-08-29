#!/usr/bin/env bats

load 'test_helper/test_helper'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "license check should work with direct commands" {
    # Arrange
    create_mock_command "very_good" "✓ Retrieved 2 licenses: MIT (2)"

    # Act - Use direct Makefile command instead of custom hook
    run make license-check

    # Assert
    assert_success
}

@test "should block push on forbidden licenses" {
    # Arrange - Mock GPL dependency
    create_mock_command "very_good" "❌ 1 dependency has banned license: some_package (GPL-3.0)" 1

    # Act - Test license-check directly instead of through lefthook to avoid recursion
    run make license-check

    # Assert
    assert_failure
    assert_output --partial "🚨 LICENSE COMPLIANCE FAILURE"
}

@test "should generate license report file" {
    # Arrange
    create_mock_command "very_good" "✓ Retrieved 3 licenses: MIT (2), Apache-2.0 (1)"

    # Act
    run make license-report

    # Assert
    assert_success
    assert_file_exists "license-report.txt"
}

@test "should check pubspec changes and trigger license check" {
    # Arrange - Mock git diff showing pubspec.yaml changes
    create_mock_command "git" "pubspec.yaml"
    create_mock_command "very_good" "✓ Retrieved 1 license: MIT (1)"

    # Act
    run make license-quick

    # Assert
    assert_success
}

@test "should allow override in emergency situations" {
    # Arrange - Mock problematic license but use override
    create_mock_command "very_good" "✓ Retrieved 1 license: unknown (1)" 1

    # Act
    run make license-override

    # Assert
    assert_success
    assert_output --partial "Override completed"
}

@test "should validate dev dependencies separately" {
    # Arrange
    create_mock_command "very_good" "✓ Retrieved 1 license: MIT (1)"

    # Act
    run make license-validate-dev

    # Assert
    assert_success
    assert_output --partial "🛠️  Checking dev dependencies only"
}

@test "should provide helpful error messages on failure" {
    # Arrange - Mock failure with detailed output
    create_mock_command "very_good" "❌ Found problematic licenses: GPL-3.0, unknown" 1

    # Act
    run make license-check

    # Assert
    assert_failure
    assert_output --partial "📋 Action items:"
    assert_output --partial "Remove packages with forbidden licenses"
}
