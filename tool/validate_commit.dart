import 'dart:io';

import 'shared/cli_runner.dart';
import 'shared/formatters/error_formatter.dart';
import 'validators/commit_validator.dart';

/// Main entry point for the commit message validation tool.
///
/// Refactored to follow SOLID principles and Clean Code practices:
/// - Single Responsibility: Each class has one clear purpose
/// - Open/Closed: Easy to extend with new validation rules
/// - Dependency Inversion: Depends on abstractions (IValidator)
/// - DRY: Eliminates code duplication with PR title validator
///
/// Usage:
///   dart run tool/validate_commit.dart "feat(auth): add login"
///   dart run tool/validate_commit.dart /path/to/commit-message.txt
///
/// Returns exit code 0 for valid commits, 1 for invalid commits.
void main(List<String> args) {
  // Create validator instance
  final validator = CommitValidator();

  // Create CLI runner with dependency injection
  final runner = CliRunner(
    validator: validator,
    toolName: 'validate_commit',
  );

  // Run the CLI tool with custom error handling
  final exitCode = runner.run(
    args,
    getInputFromArgs: (args) => args.join(' '),
    getInputFromFile: (filePath) => File(filePath).readAsStringSync(),
  );

  // Show help on validation failure
  if (exitCode != 0) {
    ErrorFormatter.showConventionalCommitHelp();
  }

  exit(exitCode);
}
