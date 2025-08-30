import 'dart:io';

import 'package:conventional_commit/conventional_commit.dart';
import 'package:logger/logger.dart';

/// Custom log output that maintains proper stream separation for CLI tools.
/// Info/debug messages go to stdout, errors/warnings go to stderr.
class _CliLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final isErrorLevel = event.level.index >= Level.warning.index;
    final target = isErrorLevel ? stderr : stdout;

    for (final line in event.lines) {
      target.writeln(line);
    }
  }
}

/// Simple printer for clean CLI output without timestamps or method traces.
class _SimplePrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return [event.message.toString()];
  }
}

/// A comprehensive validator for conventional commit messages.
/// This class validates commit messages against the Conventional Commits
/// specification
/// using the conventional_commit package for robust parsing and validation.
/// It provides detailed feedback and error messages to guide users toward
/// proper commit message formatting.
class CommitValidator {
  /// Logger instance configured for CLI tools with proper stream separation.
  static final _logger = Logger(
    printer: _SimplePrinter(),
    output: _CliLogOutput(),
  );

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
      _logger.i('✅ Merge commit detected, skipping validation');
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
    _logger.i('✅ Commit message validation passed');
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
      _logger.i('   Type: ${commit.type}');
    }

    // Display scopes if any are specified
    if (commit.scopes.isNotEmpty) {
      _logger.i('   Scope: ${commit.scopes.join(', ')}');
    }

    // Display the description if available
    if (commit.description != null) {
      _logger.i('   Description: ${commit.description}');
    }

    // Highlight breaking changes with a warning
    if (commit.isBreakingChange) {
      _logger.w('⚠️  BREAKING CHANGE detected!');
      if (commit.breakingChangeDescription != null) {
        _logger.w('   Breaking change: ${commit.breakingChangeDescription}');
      }
    }

    // Indicate if the commit has a body section
    if (commit.body != null && commit.body!.isNotEmpty) {
      _logger.i('   Has body: Yes');
    }

    // Display footer count if any footers are present
    if (commit.footers.isNotEmpty) {
      _logger.i('   Footers: ${commit.footers.length}');
    }
  }

  /// Prints an error message when the commit type is not in the allowed list.
  /// This helps users understand what types are valid and guides them to use
  /// correct types.
  static void _printTypeError(String type) {
    _logger
      ..e('❌ Invalid commit type: "$type"')
      ..e('')
      ..e('🔧 Available types: ${allowedTypes.join(', ')}');
    _printExamples();
  }

  /// Prints an error message when the description length is outside the allowed
  /// range.
  /// Conventional Commits specification recommends 3-72 characters for
  /// descriptions.
  static void _printLengthError(int length) {
    _logger
      ..e('❌ Invalid description length: $length characters')
      ..e('📏 Description must be 3-72 characters long');
    _printExamples();
  }

  /// Prints an error message when the description starts with an uppercase
  /// letter.
  /// Conventional Commits specification requires descriptions to start with
  /// lowercase letters.
  static void _printCapitalizationError() {
    _logger
      ..e('❌ Description should not start with uppercase')
      ..e('📝 Use lowercase for description');
    _printExamples();
  }

  /// Prints an error message when the commit message cannot be parsed as a
  /// conventional commit.
  /// This typically occurs when the message doesn't follow the required format.
  static void _printParsingError(String error) {
    _logger
      ..e('❌ Invalid conventional commit format')
      ..e('Parse error: $error')
      ..e('');
    _printExamples();
  }

  /// Prints helpful examples and formatting rules to guide users toward
  /// proper commit messages.
  /// This includes the correct format, examples, and key rules to remember.
  static void _printExamples() {
    _logger
      ..e('✅ Correct format: type(scope): description')
      ..e('')
      ..e('📝 Examples:')
      ..e('   feat(auth): add user registration')
      ..e('   fix(ui): resolve button alignment issue')
      ..e('   docs: update installation guide')
      ..e('   feat!: add breaking change')
      ..e('')
      ..e('📏 Rules:')
      ..e('   • 3-72 characters for description')
      ..e('   • Lowercase description')
      ..e('   • Optional scope in parentheses')
      ..e('   • Use ! for breaking changes');
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
    Logger(
        printer: _SimplePrinter(),
        output: _CliLogOutput(),
      )
      ..e('❌ Missing commit message or file path')
      ..e('💡 Usage: dart run tool/validate_commit.dart <message_or_file>');
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
    Logger(
      printer: _SimplePrinter(),
      output: _CliLogOutput(),
    ).e('❌ Empty commit message');
    exit(1);
  }

  // Perform validation and exit with appropriate code
  if (!CommitValidator.validate(commitMessage)) {
    exit(1);
  }
}
