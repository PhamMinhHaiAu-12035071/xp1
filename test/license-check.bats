#!/usr/bin/env bats

load 'test_helper/test_helper'

setup() {
    setup_test_environment
}

teardown() {
    teardown_test_environment
}

@test "should only allow business-safe licenses" {
    # Arrange - Mock pubspec.lock với safe licenses
    cat > "$TEST_TEMP_DIR/pubspec.lock" << EOF
dependencies:
  cupertino_icons:
    dependency: "direct main"
    description:
      name: cupertino_icons
      sha256: "e35129dc44c9118cee2a5603506d823bab99c68393879edb440e0090d07586b87"
      url: "https://pub.dev"
    source: hosted
    version: "1.0.6"
EOF

    # Mock very_good_cli response với safe licenses
    create_mock_command "very_good" "✓ Retrieved 1 license: MIT (1)"

    # Act
    run make license-check

    # Assert
    assert_success
    assert_output --partial "✅ All licenses are business-safe"
}

@test "should fail on GPL licenses" {
    # Arrange - Mock GPL license
    create_mock_command "very_good" "✓ Retrieved 1 license: GPL-3.0 (1)" 1

    # Act
    run make license-check

    # Assert
    assert_failure
    assert_output --partial "❌ Found forbidden licenses"
}

@test "should fail on unknown licenses" {
    # Arrange - Mock unknown license
    create_mock_command "very_good" "✓ Retrieved 1 license: unknown (1)" 1

    # Act
    run make license-check

    # Assert
    assert_failure
    assert_output --partial "❌ Found forbidden licenses"
}

@test "should pass license audit with detailed report" {
    # Arrange
    create_mock_command "very_good" "✓ Retrieved 3 licenses: MIT (2), BSD-3-Clause (1)"

    # Act
    run make license-audit

    # Assert
    assert_success
    assert_output --partial "📊 License audit completed"
}

@test "should check main dependencies only" {
    # Arrange
    create_mock_command "very_good" "✓ Retrieved 2 licenses: MIT (2)"

    # Act
    run make license-validate-main

    # Assert
    assert_success
    assert_output --partial "🎯 Checking main dependencies only"
}

@test "should generate license report file" {
    # Arrange
    create_mock_command "very_good" "✓ Retrieved 3 licenses: MIT (2), Apache-2.0 (1)"

    # Act
    run make license-report

    # Assert
    assert_success
    assert_output --partial "📊 Generating License Report"
}
