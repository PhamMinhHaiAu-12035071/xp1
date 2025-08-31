import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xp1/core/di/injection_container.dart';
import 'package:xp1/counter/counter.dart';
import 'package:xp1/l10n/l10n.dart';

/// Counter page with BlocProvider setup and UI components.
class CounterPage extends StatelessWidget {
  /// Creates counter page.
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CounterCubit>(),
      child: const CounterView(),
    );
  }
}

/// Main counter view with app bar, counter display, and action buttons.
class CounterView extends StatelessWidget {
  /// Creates counter view.
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: const Center(child: CounterText()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

/// Displays the current counter value with large text styling.
class CounterText extends StatelessWidget {
  /// Creates counter text widget.
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
