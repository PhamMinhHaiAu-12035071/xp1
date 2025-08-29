import 'dart:io';

import 'package:conventional_commit/conventional_commit.dart';

/// Console output helper for CLI tools
class Console {
  /// Write success message to stdout
  static void success(String message) {
    stdout.writeln(message);
  }

  /// Write info message to stdout
  static void info(String message) {
    stdout.writeln(message);
  }

  /// Write error message to stderr
  static void error(String message) {
    stderr.writeln(message);
  }

  /// Write warning message to stderr
  static void warning(String message) {
    stderr.writeln(message);
  }
}

/// Advanced commit message validator for Conventional Commits
class CommitValidator {
  static const allowedTypes = [
    'feat', // New feature
    'fix', // Bug fix
    'docs', // Documentation
    'style', // Code style (formatting, etc)
    'refactor', // Code refactoring
    'perf', // Performance improvement
    'test', // Tests
    'chore', // Maintenance
    'ci', // CI/CD
    'build', // Build system
    'revert', // Revert previous commit
  ];

  static const maxSubjectLength = 72;
  static const maxBodyLineLength = 100;

  /// Validates commit message according to Conventional Commits spec
  static void validate(String commitMessage) {
    // Skip validation for merge commits
    if (commitMessage.startsWith('Merge ')) {
      Console.success('✅ Merge commit detected, skipping validation');
      return;
    }

    // Skip validation for revert commits
    if (commitMessage.startsWith('Revert ')) {
      Console.success('✅ Revert commit detected, skipping validation');
      return;
    }

    try {
      final commit = ConventionalCommit.tryParse(commitMessage);
      if (commit == null) {
        throw const FormatException('Invalid conventional commit format');
      }

      // 1. Validate type
      _validateType(commit.type ?? '');

      // 2. Validate subject length
      _validateSubjectLength(commit);

      // 3. Validate description format
      _validateDescription(commit.description ?? '');

      // 4. Validate scope format (if present)
      _validateScope(commit.scopes);

      // 5. Validate body format (if present)
      _validateBody(commit.body);

      Console.success('✅ Commit message validation passed');
      _printCommitInfo(commit);
    } on Exception {
      _printError();
      exit(1);
    }
  }

  static void _validateType(String type) {
    if (!allowedTypes.contains(type)) {
      Console.error('❌ Invalid commit type: $type');
      Console.error('✅ Allowed types: ${allowedTypes.join(', ')}');
      exit(1);
    }
  }

  static void _validateSubjectLength(ConventionalCommit commit) {
    final scopes = commit.scopes;
    final scopeStr = scopes.isNotEmpty ? '(${scopes.join(',')})' : '';
    final subject =
        '${commit.type ?? ''}$scopeStr: ${commit.description ?? ''}';

    if (subject.length > maxSubjectLength) {
      Console.error(
        '❌ Subject line too long (${subject.length}/$maxSubjectLength characters)',
      );
      Console.error('💡 Current: $subject');
      exit(1);
    }
  }

  static void _validateDescription(String description) {
    if (description.isEmpty) {
      Console.error('❌ Description is required');
      exit(1);
    }

    if (description[0] != description[0].toLowerCase()) {
      Console.error('❌ Description should start with lowercase letter');
      exit(1);
    }

    if (description.endsWith('.')) {
      Console.error('❌ Description should not end with period');
      exit(1);
    }

    // Check for minimum description length
    if (description.length < 3) {
      Console.error('❌ Description too short (minimum 3 characters)');
      exit(1);
    }
  }

  static void _validateScope(List<String> scopes) {
    for (final scope in scopes) {
      if (scope.contains(' ')) {
        Console.error('❌ Scope should not contain spaces: $scope');
        exit(1);
      }
      if (scope.isEmpty) {
        Console.error('❌ Empty scope is not allowed');
        exit(1);
      }
    }
  }

  static void _validateBody(String? body) {
    if (body != null && body.isNotEmpty) {
      final lines = body.split('\n');
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.length > maxBodyLineLength) {
          Console.error(
            '❌ Body line ${i + 1} too long (${line.length}/$maxBodyLineLength characters)',
          );
          Console.error('💡 Line: ${line.substring(0, 50)}...');
          exit(1);
        }
      }
    }
  }

  static void _printCommitInfo(ConventionalCommit commit) {
    Console.info('   Type: ${commit.type ?? 'unknown'}');
    final scopes = commit.scopes;
    if (scopes.isNotEmpty) {
      Console.info('   Scope: ${scopes.join(', ')}');
    }
    Console.info('   Description: ${commit.description ?? ''}');
    if (commit.isBreakingChange) {
      Console.warning('   ⚠️  Breaking change detected');
    }
    if (commit.body != null && commit.body!.isNotEmpty) {
      Console.info('   📝 Body: ${commit.body!.split('\n').length} lines');
    }
  }

  static void _printError() {
    Console.error('❌ Invalid conventional commit format');
    Console.error('');
    Console.error('✅ Correct format:');
    Console.error('   type(scope): description');
    Console.error('   ');
    Console.error('   [optional body]');
    Console.error('   ');
    Console.error('   [optional footer(s)]');
    Console.error('');
    Console.error('📝 Examples:');
    Console.error('   feat(auth): add user registration');
    Console.error('   fix(ui): resolve button alignment issue');
    Console.error('   docs: update installation guide');
    Console.error('   chore(deps): upgrade flutter to 3.24');
    Console.error('   feat(api)!: remove deprecated endpoints');
    Console.error('');
    Console.error('🔧 Available types:');
    Console.error('   ${allowedTypes.join(', ')}');
    Console.error('');
    Console.error('📏 Rules:');
    Console.error('   • Subject line: max $maxSubjectLength characters');
    Console.error('   • Description: lowercase, no period at end');
    Console.error('   • Body lines: max $maxBodyLineLength characters');
    Console.error('   • Use ! for breaking changes');
  }
}

void main(List<String> args) {
  if (args.isEmpty) {
    Console.error('❌ Missing commit message file path');
    Console.error('💡 Usage: dart run tools/validate_commit.dart <commit-msg-file>');
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

  CommitValidator.validate(commitMessage);
}
