import 'package:xp1/core/bootstrap/interfaces/bootstrap_phase.dart';
import 'package:xp1/core/infrastructure/logging/logger_service.dart';

/// Bootstrap orchestrator implementing Chain of Responsibility pattern.
///
/// This class coordinates bootstrap phases while maintaining loose coupling
/// and enabling flexible configuration. It follows SOLID principles:
/// - SRP: Only handles orchestration logic
/// - OCP: New phases can be added without modification
/// - LSP: All phases implement the same interface
/// - ISP: Phases only expose needed operations
/// - DIP: Depends on abstractions, not concretions
class BootstrapOrchestrator {
  /// Creates orchestrator with logger dependency.
  const BootstrapOrchestrator({
    required LoggerService logger,
    required List<BootstrapPhase> phases,
  }) : _logger = logger,
       _phases = phases;

  final LoggerService _logger;
  final List<BootstrapPhase> _phases;

  /// Executes all bootstrap phases in priority order.
  ///
  /// This method implements robust error handling with:
  /// - Precondition validation
  /// - Progress tracking
  /// - Rollback on failure
  /// - Detailed logging
  ///
  /// Returns aggregated results from all phases.
  Future<Map<String, BootstrapResult>> execute() async {
    _logger.info('🚀 Starting bootstrap orchestration');

    // Sort phases by priority to ensure correct execution order
    final sortedPhases = _getSortedPhases();
    final results = <String, BootstrapResult>{};
    final executedPhases = <BootstrapPhase>[];

    try {
      // Validate all preconditions before starting
      await _validateAllPreconditions(sortedPhases);

      // Execute phases in sequence
      for (final phase in sortedPhases) {
        _logger.info('⚡ Executing phase: ${phase.phaseName}');

        try {
          final result = await _executePhaseWithTimeout(phase);
          results[phase.phaseName] = result;
          executedPhases.add(phase);

          if (!result.success && !phase.canSkip) {
            throw BootstrapException(
              'Critical phase "${phase.phaseName}" failed: ${result.message}',
              phase: phase.phaseName,
              canRetry: true,
            );
          }

          if (result.success) {
            _logger.info('✅ Phase completed: ${phase.phaseName}');
          } else {
            _logger.warning(
              '⚠️  Phase skipped: ${phase.phaseName} - '
              '${result.message}',
            );
          }
        } on BootstrapException {
          rethrow; // Re-throw bootstrap exceptions as-is
        } on Exception catch (e, stackTrace) {
          _logger.error('Phase ${phase.phaseName} failed', e, stackTrace);

          final exception = BootstrapException(
            'Phase "${phase.phaseName}" failed with unexpected error',
            phase: phase.phaseName,
            originalError: e,
            canRetry: phase.canSkip,
          );

          if (!phase.canSkip) {
            // Rollback executed phases on critical failure
            await _rollbackPhases(executedPhases);
            throw exception;
          }

          // Record failure for skippable phases
          results[phase.phaseName] = BootstrapResult.failure(exception.message);
        }
      }

      _logger.info('🎉 Bootstrap orchestration completed successfully');
      return results;
    } on BootstrapException {
      _logger.error('Bootstrap orchestration failed');
      rethrow;
    } on Exception catch (e, stackTrace) {
      _logger.error('Unexpected bootstrap failure', e, stackTrace);
      await _rollbackPhases(executedPhases);
      throw BootstrapException(
        'Bootstrap orchestration failed unexpectedly',
        originalError: e,
      );
    }
  }

  /// Gets phases sorted by priority (lower numbers first).
  List<BootstrapPhase> _getSortedPhases() {
    final sorted = List<BootstrapPhase>.from(_phases)
      ..sort((a, b) => a.priority.compareTo(b.priority));
    return sorted;
  }

  /// Validates preconditions for all phases before execution.
  Future<void> _validateAllPreconditions(List<BootstrapPhase> phases) async {
    _logger.info('🔍 Validating phase preconditions...');

    for (final phase in phases) {
      try {
        await phase.validatePreconditions();
        _logger.debug('✅ Preconditions valid: ${phase.phaseName}');
      } on Exception catch (e, stackTrace) {
        _logger.error(
          'Precondition validation failed: ${phase.phaseName}',
          e,
          stackTrace,
        );
        throw BootstrapException(
          'Precondition validation failed for "${phase.phaseName}"',
          phase: phase.phaseName,
          originalError: e,
        );
      }
    }

    _logger.info('✅ All preconditions validated');
  }

  /// Executes a phase with timeout protection.
  Future<BootstrapResult> _executePhaseWithTimeout(BootstrapPhase phase) async {
    const timeout = Duration(minutes: 5); // Configurable timeout

    return phase.execute().timeout(
      timeout,
      onTimeout: () {
        _logger.error('Phase ${phase.phaseName} timed out');
        throw BootstrapException(
          'Phase "${phase.phaseName}" exceeded timeout of '
          '${timeout.inSeconds}s',
          phase: phase.phaseName,
          canRetry: true,
        );
      },
    );
  }

  /// Rolls back executed phases in reverse order.
  Future<void> _rollbackPhases(List<BootstrapPhase> executedPhases) async {
    if (executedPhases.isEmpty) return;

    _logger.warning('🔄 Rolling back ${executedPhases.length} phases...');

    // Rollback in reverse order
    for (final phase in executedPhases.reversed) {
      try {
        await phase.rollback();
        _logger.info('↩️  Rolled back: ${phase.phaseName}');
      } on Exception catch (e, stackTrace) {
        _logger.error('Rollback failed for ${phase.phaseName}', e, stackTrace);
        // Continue rollback even if one phase fails
      }
    }

    _logger.warning('🔄 Rollback completed');
  }

  /// Gets execution summary for monitoring and debugging.
  String getExecutionSummary(Map<String, BootstrapResult> results) {
    final successful = results.values.where((r) => r.success).length;
    final failed = results.values.where((r) => !r.success).length;
    final total = results.length;

    return 'Bootstrap Summary: $successful/$total phases successful, '
        '$failed failed/skipped';
  }
}
