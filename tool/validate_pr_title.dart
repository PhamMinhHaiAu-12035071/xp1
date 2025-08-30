import 'dart:io';

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

/// PR title validator following semantic conventions
class PrTitleValidator {
  /// Logger instance configured for CLI tools with proper stream separation.
  static final _logger = Logger(
    printer: _SimplePrinter(),
    output: _CliLogOutput(),
  );

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
    r'(\([^)]+\))?!?: .{3,72}$',
  );

  /// Validates PR title according to Conventional Commits spec
  static bool validate(String prTitle) {
    // Check pattern match
    if (!_prTitlePattern.hasMatch(prTitle)) {
      _printError();
      return false;
    }

    // Validate description starts with lowercase letter
    final parts = prTitle.split(': ');
    if (parts.length >= 2) {
      final description = parts.sublist(1).join(': ');
      if (description.isNotEmpty &&
          description[0] == description[0].toUpperCase()) {
        _printError();
        return false;
      }
    }

    _logger.i('✅ PR title validation passed');
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
        _logger.i('   Type: ${scopeMatch.group(1)}');
        if (scopeMatch.group(3) != null) {
          _logger.i('   Scope: ${scopeMatch.group(3)}');
        }
        if (scopeMatch.group(4) != null) {
          _logger.i('   Breaking Change: Yes');
        }
        _logger.i('   Description: $description');
      }
    }
  }

  static void _printError() {
    _logger
      ..e('❌ Invalid semantic PR title format')
      ..e('')
      ..e('✅ Correct format: type(scope): description')
      ..e('✅ Breaking change: type(scope)!: description')
      ..e('')
      ..e('📝 Examples:')
      ..e('   feat(auth): add user registration')
      ..e('   fix(ui): resolve button alignment issue')
      ..e('   feat(api)!: change authentication system')
      ..e('   docs: update installation guide')
      ..e('')
      ..e('🔧 Available types: ${allowedTypes.join(', ')}')
      ..e('📏 Rules: 3-72 characters, lowercase description');
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
            final type = parts[0];
            final description = parts.sublist(1).join(' ').replaceAll('-', ' ');
            // Check if type is valid semantic type
            if (PrTitleValidator.allowedTypes.contains(type)) {
              prTitle = '$type: $description';
            } else {
              prTitle = parts.sublist(1).join(' ').replaceAll('-', ' ');
            }
          } else {
            prTitle = branchName.replaceAll('-', ' ');
          }
        } else {
          prTitle = branchName.replaceAll('-', ' ');
        }
        Logger(
          printer: _SimplePrinter(),
          output: _CliLogOutput(),
        ).i('📝 Using branch name as PR title: $prTitle');
      } else {
        Logger(
            printer: _SimplePrinter(),
            output: _CliLogOutput(),
          )
          ..e('❌ Cannot determine PR title')
          ..e('💡 Usage: dart run tool/validate_pr_title.dart <pr_title>');
        exit(1);
      }
    } on Exception catch (e) {
      Logger(
          printer: _SimplePrinter(),
          output: _CliLogOutput(),
        )
        ..e('❌ Cannot determine PR title: $e')
        ..e('💡 Usage: dart run tool/validate_pr_title.dart <pr_title>');
      exit(1);
    }
  }

  if (prTitle.isEmpty) {
    Logger(
      printer: _SimplePrinter(),
      output: _CliLogOutput(),
    ).e('❌ Empty PR title');
    exit(1);
  }

  if (!PrTitleValidator.validate(prTitle)) {
    exit(1);
  }
}
