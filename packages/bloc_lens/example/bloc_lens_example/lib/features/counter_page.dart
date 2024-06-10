import 'package:bloc_lens_example/features/counters_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final counters = context.watch<CountersCubit>().counters;
    final counter = counters.at(index);

    if (counter == null) {
      return const Scaffold();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Counter #${index + 1}'),
        actions: [
          IconButton(
            onPressed: () {
              counters.removeAt(index);
              Navigator.of(context).pop();
            },
            isSelected: false,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              counter.get().toString(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 32),
            IconButton.filledTonal(
              icon: const Icon(Icons.add),
              iconSize: 64,
              onPressed: () => counter.set(counter.get() + 1),
            ),
            const SizedBox(height: 16),
            IconButton.outlined(
              icon: const Icon(Icons.remove),
              iconSize: 32,
              onPressed: () => counter.set(counter.get() - 1),
            ),
          ],
        ),
      ),
    );
  }
}
