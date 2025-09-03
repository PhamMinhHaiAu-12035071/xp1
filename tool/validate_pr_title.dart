import 'dart:io';

import 'shared/cli_logger.dart';
import 'shared/cli_runner.dart';
import 'shared/formatters/error_formatter.dart';
import 'validators/pr_title_validator.dart';

/// Main entry point for the PR title validation tool.
///
/// Refactored to follow SOLID principles and Clean Code practices:
/// - Single Responsibility: Each class has one clear purpose
/// - Open/Closed: Easy to extend with new validation rules
/// - Dependency Inversion: Depends on abstractions (IValidator)
/// - DRY: Eliminates code duplication with commit validator
///
/// Usage:
///   dart run tool/validate_pr_title.dart "feat(auth): add user registration"
///   dart run tool/validate_pr_title.dart (uses current branch name)
///
/// Returns exit code 0 for valid PR titles, 1 for invalid titles.
void main(List<String> args) {
  // Create validator instance
  final validator = PrTitleValidator();

  // Create enhanced CLI runner with branch name fallback
  final runner = PrTitleCliRunner(
    validator: validator,
    toolName: 'validate_pr_title',
  );

  // Run the CLI tool with branch name fallback support
  final exitCode = runner.runWithBranchFallback(args);

  // Show help on validation failure
  if (exitCode != 0) {
    ErrorFormatter.showPrTitleHelp();
  }

  exit(exitCode);
}

/// Enhanced CLI runner for PR title validation with branch name fallback.
///
/// Extends the base CLI runner functionality to handle the special case
/// where PR titles can be derived from git branch names when no arguments
/// are provided.
class PrTitleCliRunner extends CliRunner {
  const PrTitleCliRunner({
    required super.validator,
    required super.toolName,
  });

  /// Runs PR title validation with branch name fallback.
  ///
  /// If no arguments are provided, attempts to derive a PR title from
  /// the current git branch name using conventional naming patterns.
  int runWithBranchFallback(List<String> args) {
    if (args.isNotEmpty) {
      // Standard CLI runner behavior when args are provided
      return run(
        args,
        getInputFromArgs: (args) => args.join(' '),
      );
    }

    // No arguments provided - try to get PR title from branch name
    try {
      final branchName = _getCurrentBranchName();
      final prTitle = _convertBranchToPrTitle(branchName);

      CliLogger.info('📝 Branch name: $branchName');
      CliLogger.info('📝 Using branch name as PR title: $prTitle');

      // Validate the derived PR title
      final result = validator.validate(prTitle);
      return result.isValid ? 0 : 1;
    } on Exception catch (e) {
      CliLogger.error('❌ Cannot determine PR title: $e');
      CliLogger.error(
        '💡 Usage: dart run tool/validate_pr_title.dart <pr_title>',
      );
      return 1;
    }
  }

  /// Gets the current git branch name.
  String _getCurrentBranchName() {
    final result = Process.runSync('git', [
      'rev-parse',
      '--abbrev-ref',
      'HEAD',
    ]);

    if (result.exitCode != 0) {
      throw Exception('Failed to get current branch name');
    }

    return result.stdout.toString().trim();
  }

  /// Converts a branch name to a PR title.
  ///
  /// Uses the BranchNameCleaner utility to apply consistent conversion
  /// rules for branch names to PR titles.
  String _convertBranchToPrTitle(String branchName) {
    // Try conventional conversion first
    final conventionalTitle = BranchNameCleaner.branchToConventionalTitle(
      branchName,
    );
    if (conventionalTitle != null) {
      return conventionalTitle;
    }

    // Fall back to cleaned branch name
    final cleanedName = BranchNameCleaner.cleanBranchName(branchName);
    if (cleanedName.isEmpty) {
      throw Exception(
        'Cannot derive meaningful PR title from branch name',
      );
    }

    return cleanedName;
  }
}
