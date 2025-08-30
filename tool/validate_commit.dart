import 'dart:io';

import 'package:conventional_commit/conventional_commit.dart';

/// A utility class for handling console output with proper stream separation.
/// This ensures that success/info messages go to stdout and errors/warnings go to stderr.
/// This is important for CLI tools to maintain proper output redirection
/// capabilities.
class Console {
  /// Writes a success message to stdout.
  /// Use this for positive feedback and successful operations.
  static void success(String message) => stdout.writeln(message);

  /// Writes an informational message to stdout.
  /// Use this for displaying details about the current operation.
  static void info(String message) => stdout.writeln(message);

  /// Writes an error message to stderr.
  /// Use this for critical errors that should prevent further execution.
  static void error(String message) => stderr.writeln(message);

  /// Writes a warning message to stderr.
  /// Use this for non-critical issues that don't prevent execution.
  static void warning(String message) => stderr.writeln(message);
}

/// A comprehensive validator for conventional commit messages.
/// This class validates commit messages against the Conventional Commits
/// specification
/// using the conventional_commit package for robust parsing and validation.
/// It provides detailed feedback and error messages to guide users toward
/// proper commit message formatting.
class CommitValidator {
  /// List of allowed conventional commit types as defined in the specification.
  /// These represent the standard types that can be used in commit messages.
  static const allowedTypes = [
    'feat', // New features
    'fix', // Bug fixes
    'docs', // Documentation changes
    'style', // Code style changes (formatting, etc.)
    'refactor', // Code refactoring
    'perf', // Performance improvements
    'test', // Adding or updating tests
    'chore', // Maintenance tasks
    'ci', // CI/CD related changes
    'build', // Build system changes
    'revert', // Reverting previous changes
  ];

  /// Validates a commit message against the Conventional Commits specification.
  ///
  /// This method performs comprehensive validation including:
  /// - Parsing the commit message using the conventional_commit package
  /// - Validating the commit type against allowed types
  /// - Checking description length constraints (3-72 characters)
  /// - Ensuring description starts with lowercase letter
  /// - Providing detailed feedback and error messages
  ///
  /// Returns true if the commit message is valid, false otherwise.
  static bool validate(String commitMessage) {
    // Skip validation for merge commits as they follow a different format
    if (commitMessage.startsWith('Merge ')) {
      Console.success(
        '✅ Merge commit detected, skipping validation',
      );
      return true;
    }

    // Parse the commit message using the conventional_commit package
    final parsedCommit = ConventionalCommit.tryParse(commitMessage);

    // If parsing fails, the message doesn't follow conventional commit format
    if (parsedCommit == null) {
      _printParsingError('Unable to parse conventional commit format');
      return false;
    }

    // Validate that the commit type is in our allowed list
    if (parsedCommit.type != null &&
        !allowedTypes.contains(parsedCommit.type)) {
      _printTypeError(parsedCommit.type!);
      return false;
    }

    // Validate description length according to conventional commits spec
    final description = parsedCommit.description;
    if (description != null &&
        (description.length < 3 || description.length > 72)) {
      _printLengthError(description.length);
      return false;
    }

    // Validate description format - should start with lowercase letter
    if (description != null &&
        description.isNotEmpty &&
        description[0] == description[0].toUpperCase()) {
      _printCapitalizationError();
      return false;
    }

    // Validation passed - provide success feedback
    Console.success('✅ Commit message validation passed');
    _printCommitInfo(parsedCommit);
    return true;
  }

  /// Prints detailed information about the successfully parsed commit.
  /// This provides users with comprehensive feedback about their commit
  /// structure, including type, scope, description, and any special markers
  /// like breaking changes.
  static void _printCommitInfo(ConventionalCommit commit) {
    // Display the commit type if available
    if (commit.type != null) {
      Console.info('   Type: ${commit.type}');
    }

    // Display scopes if any are specified
    if (commit.scopes.isNotEmpty) {
      Console.info('   Scope: ${commit.scopes.join(', ')}');
    }

    // Display the description if available
    if (commit.description != null) {
      Console.info('   Description: ${commit.description}');
    }

    // Highlight breaking changes with a warning
    if (commit.isBreakingChange) {
      Console.warning('⚠️  BREAKING CHANGE detected!');
      if (commit.breakingChangeDescription != null) {
        Console.warning(
          '   Breaking change: ${commit.breakingChangeDescription}',
        );
      }
    }

    // Indicate if the commit has a body section
    if (commit.body != null && commit.body!.isNotEmpty) {
      Console.info('   Has body: Yes');
    }

    // Display footer count if any footers are present
    if (commit.footers.isNotEmpty) {
      Console.info('   Footers: ${commit.footers.length}');
    }
  }

  /// Prints an error message when the commit type is not in the allowed list.
  /// This helps users understand what types are valid and guides them to use
  /// correct types.
  static void _printTypeError(String type) {
    Console.error('❌ Invalid commit type: "$type"');
    Console.error('');
    Console.error('🔧 Available types: ${allowedTypes.join(', ')}');
    _printExamples();
  }

  /// Prints an error message when the description length is outside the allowed
  /// range.
  /// Conventional Commits specification recommends 3-72 characters for
  /// descriptions.
  static void _printLengthError(int length) {
    Console.error('❌ Invalid description length: $length characters');
    Console.error('📏 Description must be 3-72 characters long');
    _printExamples();
  }

  /// Prints an error message when the description starts with an uppercase
  /// letter.
  /// Conventional Commits specification requires descriptions to start with
  /// lowercase letters.
  static void _printCapitalizationError() {
    Console.error('❌ Description should not start with uppercase');
    Console.error('📝 Use lowercase for description');
    _printExamples();
  }

  /// Prints an error message when the commit message cannot be parsed as a
  /// conventional commit.
  /// This typically occurs when the message doesn't follow the required format.
  static void _printParsingError(String error) {
    Console.error('❌ Invalid conventional commit format');
    Console.error('Parse error: $error');
    Console.error('');
    _printExamples();
  }

  /// Prints helpful examples and formatting rules to guide users toward
  /// proper commit messages.
  /// This includes the correct format, examples, and key rules to remember.
  static void _printExamples() {
    Console.error('✅ Correct format: type(scope): description');
    Console.error('');
    Console.error('📝 Examples:');
    Console.error('   feat(auth): add user registration');
    Console.error('   fix(ui): resolve button alignment issue');
    Console.error('   docs: update installation guide');
    Console.error('   feat!: add breaking change');
    Console.error('');
    Console.error('📏 Rules:');
    Console.error('   • 3-72 characters for description');
    Console.error('   • Lowercase description');
    Console.error('   • Optional scope in parentheses');
    Console.error('   • Use ! for breaking changes');
  }
}

/// Main entry point for the commit message validation tool.
/// This CLI tool validates commit messages against the Conventional Commits
/// specification.
///
/// Usage:
///   dart run tool/validate_commit.dart "feat(auth): add login"
///   dart run tool/validate_commit.dart /path/to/commit-message.txt
///
/// The tool accepts either:
/// - A direct commit message as arguments
/// - A file path containing the commit message
///
/// Returns exit code 0 for valid commits, 1 for invalid commits.
void main(List<String> args) {
  // Ensure at least one argument is provided
  if (args.isEmpty) {
    Console.error('❌ Missing commit message or file path');
    Console.error(
      '💡 Usage: dart run tool/validate_commit.dart <message_or_file>',
    );
    exit(1);
  }

  String commitMessage;

  // Determine if the first argument is a file path or direct commit message
  final inputArg = args[0];
  final possibleFile = File(inputArg);

  // If it's a valid file path (exists and contains no spaces), read from file
  if (possibleFile.existsSync() && !inputArg.contains(' ')) {
    commitMessage = possibleFile.readAsStringSync().trim();
  } else {
    // Otherwise, treat all arguments as the commit message (join with spaces)
    commitMessage = args.join(' ').trim();
  }

  // Ensure the commit message is not empty
  if (commitMessage.isEmpty) {
    Console.error('❌ Empty commit message');
    exit(1);
  }

  // Perform validation and exit with appropriate code
  if (!CommitValidator.validate(commitMessage)) {
    exit(1);
  }
}
