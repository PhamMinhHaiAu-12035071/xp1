import 'dart:io';

/// Console output helper for CLI tools
class Console {
  /// Write success message to stdout
  static void success(String message) => stdout.writeln(message);

  /// Write info message to stdout
  static void info(String message) => stdout.writeln(message);

  /// Write error message to stderr
  static void error(String message) => stderr.writeln(message);

  /// Write warning message to stderr
  static void warning(String message) => stderr.writeln(message);
}

/// PR title validator following semantic conventions
class PrTitleValidator {
  static const allowedTypes = [
    'feat',
    'fix',
    'docs',
    'style',
    'refactor',
    'perf',
    'test',
    'chore',
    'ci',
    'build',
    'revert',
  ];

  static final _prTitlePattern = RegExp(
    '^(${allowedTypes.join('|')})'
    r'(\([^)]+\))!?: .{3,72}$',
  );

  /// Validates PR title according to Conventional Commits spec
  static bool validate(String prTitle) {
    // Check pattern match
    if (!_prTitlePattern.hasMatch(prTitle)) {
      _printError();
      return false;
    }

    Console.success('✅ PR title validation passed');
    _printPrInfo(prTitle);
    return true;
  }

  static void _printPrInfo(String title) {
    final parts = title.split(': ');
    if (parts.length >= 2) {
      final typeScope = parts[0];
      final description = parts.sublist(1).join(': ');

      final scopeMatch = RegExp(r'(\w+)(\((.+)\))?(!)?').firstMatch(typeScope);
      if (scopeMatch != null) {
        Console.info('   Type: ${scopeMatch.group(1)}');
        if (scopeMatch.group(3) != null) {
          Console.info('   Scope: ${scopeMatch.group(3)}');
        }
        if (scopeMatch.group(4) != null) {
          Console.info('   Breaking Change: Yes');
        }
        Console.info('   Description: $description');
      }
    }
  }

  static void _printError() {
    Console.error('❌ Invalid semantic PR title format');
    Console.error('');
    Console.error('✅ Correct format: type(scope): description');
    Console.error('✅ Breaking change: type(scope)!: description');
    Console.error('');
    Console.error('📝 Examples:');
    Console.error('   feat(auth): add user registration');
    Console.error('   fix(ui): resolve button alignment issue');
    Console.error('   feat(api)!: change authentication system');
    Console.error('   docs: update installation guide');
    Console.error('');
    Console.error('🔧 Available types: ${allowedTypes.join(', ')}');
    Console.error('📏 Rules: 3-72 characters, lowercase description');
  }
}

void main(List<String> args) {
  // For local testing, we can pass PR title as argument
  // In CI, this would get PR title from environment variables
  String prTitle;

  if (args.isNotEmpty) {
    prTitle = args.join(' ');
  } else {
    // Try to get from git (current branch name as PR title simulation)
    try {
      final result = Process.runSync('git', [
        'rev-parse',
        '--abbrev-ref',
        'HEAD',
      ]);
      if (result.exitCode == 0) {
        final branchName = result.stdout.toString().trim();
        // Convert branch name to PR title format if it follows pattern
        if (branchName.contains('/')) {
          final parts = branchName.split('/');
          if (parts.length >= 2) {
            prTitle = parts.sublist(1).join(' ').replaceAll('-', ' ');
          } else {
            prTitle = branchName.replaceAll('-', ' ');
          }
        } else {
          prTitle = branchName.replaceAll('-', ' ');
        }
        Console.info('📝 Using branch name as PR title: $prTitle');
      } else {
        Console.error('❌ Cannot determine PR title');
        Console.error(
          '💡 Usage: dart run tools/validate_pr_title.dart '
          '<pr_title>',
        );
        exit(1);
      }
    } on Exception catch (e) {
      Console.error('❌ Cannot determine PR title: $e');
      Console.error(
        '💡 Usage: dart run tools/validate_pr_title.dart '
        '<pr_title>',
      );
      exit(1);
    }
  }

  if (prTitle.isEmpty) {
    Console.error('❌ Empty PR title');
    exit(1);
  }

  if (!PrTitleValidator.validate(prTitle)) {
    exit(1);
  }
}
