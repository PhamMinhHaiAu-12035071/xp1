import 'dart:io';

import 'cli_logger.dart';
import 'validation_result.dart';
import 'validator_interface.dart';

/// CLI runner utility following Single Responsibility Principle.
/// Handles common command-line interface patterns for validation tools.
/// 
/// Eliminates code duplication between different CLI validation tools
/// while providing consistent error handling and user experience.
class CliRunner {

  /// Creates a CLI runner with the specified validator and tool name.
  const CliRunner({
    required this.validator,
    required this.toolName,
  });
  /// The validator instance to use for validation.
  final IValidator<String> validator;

  /// Tool name for usage messages.
  final String toolName;

  /// Runs the CLI validation tool with the provided arguments.
  /// 
  /// [args] Command line arguments
  /// [getInputFromArgs] Function to extract input from arguments
  /// [getInputFromFile] Optional function to get input from file
  /// 
  /// Returns exit code (0 for success, 1 for failure)
  int run(
    List<String> args, {
    required String Function(List<String>) getInputFromArgs,
    String Function(String)? getInputFromFile,
  }) {
    try {
      // Get input string to validate
      final input = _getInput(args, getInputFromArgs, getInputFromFile);
      
      if (input == null) {
        return 1; // Error already logged
      }

      // Perform validation
      final result = validator.validate(input);
      
      // Handle validation result
      return _handleValidationResult(result);
    } on Exception catch (e) {
      CliLogger.error('❌ Unexpected error: $e');
      _showUsage();
      return 1;
    }
  }

  /// Gets input string from arguments or file.
  String? _getInput(
    List<String> args,
    String Function(List<String>) getInputFromArgs,
    String Function(String)? getInputFromFile,
  ) {
    // Check if arguments are provided
    if (args.isEmpty) {
      CliLogger.error('❌ Missing input');
      _showUsage();
      return null;
    }

    // Try to get input from arguments first
    var input = getInputFromArgs(args);
    
    // If getInputFromFile is provided and first arg looks like a file
    if (getInputFromFile != null && args.length == 1) {
      final possibleFile = File(args[0]);
      if (possibleFile.existsSync() && !args[0].contains(' ')) {
        try {
          input = getInputFromFile(args[0]);
        } on Exception catch (e) {
          CliLogger.error('❌ Error reading file: $e');
          return null;
        }
      }
    }

    // Validate input is not empty
    if (input.trim().isEmpty) {
      CliLogger.error('❌ Empty input');
      return null;
    }

    return input.trim();
  }

  /// Handles validation result and returns appropriate exit code.
  int _handleValidationResult(ValidationResult result) {
    if (result.isValid) {
      // Show success message
      CliLogger.info(result.message);
      
      // Show validation details
      _showValidationDetails(result);
      
      return 0;
    } else {
      // Show error message
      CliLogger.error(result.message);
      
      // Show specific errors
      _showValidationErrors(result);
      
      return 1;
    }
  }

  /// Shows validation details for successful validation.
  void _showValidationDetails(ValidationResult result) {
    final details = result.details;
    
    if (details['type'] != null) {
      CliLogger.info('   Type: ${details['type']}');
    }
    
    if (details['scope'] != null) {
      CliLogger.info('   Scope: ${details['scope']}');
    }
    
    if (details['description'] != null) {
      CliLogger.info('   Description: ${details['description']}');
    }
    
    if (details['isBreakingChange'] == true) {
      CliLogger.warning('⚠️  BREAKING CHANGE detected!');
      if (details['breakingChangeDescription'] != null) {
        CliLogger.warning(
          '   Breaking change: ${details['breakingChangeDescription']}',
        );
      }
    }
    
    if (details['hasBody'] == true) {
      CliLogger.info('   Has body: Yes');
    }
    
    final footerCount = details['footerCount'] as int?;
    if (footerCount != null && footerCount > 0) {
      CliLogger.info('   Footers: $footerCount');
    }
  }

  /// Shows validation errors for failed validation.
  void _showValidationErrors(ValidationResult result) {
    if (result.errors.isNotEmpty) {
      CliLogger.error('');
      for (final error in result.errors) {
        CliLogger.error('• ${error.message}');
      }
    }
  }

  /// Shows usage information.
  void _showUsage() {
    CliLogger.error('💡 Usage: dart run tool/$toolName.dart <input>');
    CliLogger.error('💡 Or: dart run tool/$toolName.dart <file_path>');
  }
}

/// File input helper for reading validation input from files.
class FileInputHelper {
  /// Reads content from a file and returns it as a string.
  /// 
  /// [filePath] Path to the file to read
  /// Returns file content as trimmed string
  /// Throws exception if file cannot be read
  static String readFromFile(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('File not found: $filePath');
    }
    
    return file.readAsStringSync().trim();
  }
}
