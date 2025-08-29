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

/// Simple and focused commit message validator
class CommitValidator {
  static const allowedTypes = [
    'feat', 'fix', 'docs', 'style', 'refactor',
    'perf', 'test', 'chore', 'ci', 'build', 'revert'
  ];

  static final _commitPattern = RegExp(
    '^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)'
    r'(\(.+\))?: .{3,72}$',
  );

  /// Validates commit message according to Conventional Commits spec
  static bool validate(String commitMessage) {
    // Skip validation for merge/revert commits
    if (commitMessage.startsWith('Merge ') || 
        commitMessage.startsWith('Revert ')) {
      Console.success('✅ Special commit type detected, skipping validation');
      return true;
    }

    // Check pattern match
    if (!_commitPattern.hasMatch(commitMessage)) {
      _printError();
      return false;
    }

    Console.success('✅ Commit message validation passed');
    _printCommitInfo(commitMessage);
    return true;
  }

  static void _printCommitInfo(String message) {
    final parts = message.split(': ');
    if (parts.length >= 2) {
      final typeScope = parts[0];
      final description = parts.sublist(1).join(': ');
      
      final scopeMatch = RegExp(r'(\w+)(\((.+)\))?').firstMatch(typeScope);
      if (scopeMatch != null) {
        Console.info('   Type: ${scopeMatch.group(1)}');
        if (scopeMatch.group(3) != null) {
          Console.info('   Scope: ${scopeMatch.group(3)}');
        }
        Console.info('   Description: $description');
      }
    }
  }

  static void _printError() {
    Console.error('❌ Invalid conventional commit format');
    Console.error('');
    Console.error('✅ Correct format: type(scope): description');
    Console.error('');
    Console.error('📝 Examples:');
    Console.error('   feat(auth): add user registration');
    Console.error('   fix(ui): resolve button alignment issue');
    Console.error('   docs: update installation guide');
    Console.error('');
    Console.error('🔧 Available types: ${allowedTypes.join(', ')}');
    Console.error('📏 Rules: 3-72 characters, lowercase description');
  }
}

void main(List<String> args) {
  if (args.isEmpty) {
    Console.error('❌ Missing commit message file path');
    Console.error('💡 Usage: dart run tools/validate_commit.dart <file>');
    exit(1);
  }

  final commitMsgFile = File(args[0]);
  if (!commitMsgFile.existsSync()) {
    Console.error('❌ Commit message file not found: ${args[0]}');
    exit(1);
  }

  final commitMessage = commitMsgFile.readAsStringSync().trim();
  if (commitMessage.isEmpty) {
    Console.error('❌ Empty commit message');
    exit(1);
  }

  if (!CommitValidator.validate(commitMessage)) {
    exit(1);
  }
}
