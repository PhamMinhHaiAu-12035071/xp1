import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:xp1/features/splash/presentation/cubit/splash_state.dart';

/// Simplified splash cubit with timer-based navigation.
///
/// This cubit manages a simple splash screen that displays for 2 seconds
/// and then emits ready state for navigation.
@injectable
class SplashCubit extends Cubit<SplashState> {
  /// Creates splash cubit without dependencies.
  SplashCubit() : super(const SplashState.loading());

  Timer? _timer;

  /// Starts the splash sequence with 2-second timer.
  void startSplash() {
    _timer = Timer(const Duration(seconds: 2), () {
      if (!isClosed) {
        emit(const SplashState.ready());
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
