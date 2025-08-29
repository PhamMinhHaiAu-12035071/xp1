import 'package:bloc/bloc.dart';

/// Counter state management with increment and decrement operations.
class CounterCubit extends Cubit<int> {
  /// Creates counter with initial value of 0.
  CounterCubit() : super(0);

  /// Increments counter by 1.
  void increment() => emit(state + 1);

  /// Decrements counter by 1.
  void decrement() => emit(state - 1);
}
