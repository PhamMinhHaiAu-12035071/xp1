// CLI tool requires console output for user feedback
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:conventional_commit/conventional_commit.dart';

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
      print('✅ Merge commit detected, skipping validation');
      return;
    }

    // Skip validation for revert commits
    if (commitMessage.startsWith('Revert ')) {
      print('✅ Revert commit detected, skipping validation');
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

      print('✅ Commit message validation passed');
      _printCommitInfo(commit);
    } on Exception {
      _printError();
      exit(1);
    }
  }

  static void _validateType(String type) {
    if (!allowedTypes.contains(type)) {
      print('❌ Invalid commit type: $type');
      print('✅ Allowed types: ${allowedTypes.join(', ')}');
      exit(1);
    }
  }

  static void _validateSubjectLength(ConventionalCommit commit) {
    final scopes = commit.scopes;
    final scopeStr = scopes.isNotEmpty ? '(${scopes.join(',')})' : '';
    final subject =
        '${commit.type ?? ''}$scopeStr: ${commit.description ?? ''}';

    if (subject.length > maxSubjectLength) {
      print(
        '❌ Subject line too long (${subject.length}/$maxSubjectLength characters)',
      );
      print('💡 Current: $subject');
      exit(1);
    }
  }

  static void _validateDescription(String description) {
    if (description.isEmpty) {
      print('❌ Description is required');
      exit(1);
    }

    if (description[0] != description[0].toLowerCase()) {
      print('❌ Description should start with lowercase letter');
      exit(1);
    }

    if (description.endsWith('.')) {
      print('❌ Description should not end with period');
      exit(1);
    }

    // Check for minimum description length
    if (description.length < 3) {
      print('❌ Description too short (minimum 3 characters)');
      exit(1);
    }
  }

  static void _validateScope(List<String> scopes) {
    for (final scope in scopes) {
      if (scope.contains(' ')) {
        print('❌ Scope should not contain spaces: $scope');
        exit(1);
      }
      if (scope.isEmpty) {
        print('❌ Empty scope is not allowed');
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
          print(
            '❌ Body line ${i + 1} too long (${line.length}/$maxBodyLineLength characters)',
          );
          print('💡 Line: ${line.substring(0, 50)}...');
          exit(1);
        }
      }
    }
  }

  static void _printCommitInfo(ConventionalCommit commit) {
    print('   Type: ${commit.type ?? 'unknown'}');
    final scopes = commit.scopes;
    if (scopes.isNotEmpty) {
      print('   Scope: ${scopes.join(', ')}');
    }
    print('   Description: ${commit.description ?? ''}');
    if (commit.isBreakingChange) {
      print('   ⚠️  Breaking change detected');
    }
    if (commit.body != null && commit.body!.isNotEmpty) {
      print('   📝 Body: ${commit.body!.split('\n').length} lines');
    }
  }

  static void _printError() {
    print('❌ Invalid conventional commit format');
    print('');
    print('✅ Correct format:');
    print('   type(scope): description');
    print('   ');
    print('   [optional body]');
    print('   ');
    print('   [optional footer(s)]');
    print('');
    print('📝 Examples:');
    print('   feat(auth): add user registration');
    print('   fix(ui): resolve button alignment issue');
    print('   docs: update installation guide');
    print('   chore(deps): upgrade flutter to 3.24');
    print('   feat(api)!: remove deprecated endpoints');
    print('');
    print('🔧 Available types:');
    print('   ${allowedTypes.join(', ')}');
    print('');
    print('📏 Rules:');
    print('   • Subject line: max $maxSubjectLength characters');
    print('   • Description: lowercase, no period at end');
    print('   • Body lines: max $maxBodyLineLength characters');
    print('   • Use ! for breaking changes');
  }
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('❌ Missing commit message file path');
    print('💡 Usage: dart run tools/validate_commit.dart <commit-msg-file>');
    exit(1);
  }

  final commitMsgFile = File(args[0]);
  if (!commitMsgFile.existsSync()) {
    print('❌ Commit message file not found: ${args[0]}');
    exit(1);
  }

  final commitMessage = commitMsgFile.readAsStringSync().trim();

  if (commitMessage.isEmpty) {
    print('❌ Empty commit message');
    exit(1);
  }

  CommitValidator.validate(commitMessage);
}
