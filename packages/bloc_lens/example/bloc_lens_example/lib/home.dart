import 'package:bloc_lens_example/features/counter_page.dart';
import 'package:bloc_lens_example/features/counters_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final counters = context.watch<CountersCubit>().counters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => counters.add(0),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        itemCount: counters.get().length,
        padding: const EdgeInsets.all(8),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _CounterCard(index: index),
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final counters = context.watch<CountersCubit>().counters;
    final counter = counters.at(index);

    if (counter == null) {
      return const SizedBox.shrink();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.outlined(
              icon: const Icon(Icons.remove),
              onPressed: () => counter.set(counter.get() - 1),
            ),
            const SizedBox(width: 8),
            IconButton.outlined(
              icon: const Icon(Icons.add),
              onPressed: () => counter.set(counter.get() + 1),
            ),
            const SizedBox(width: 16),
            Text(counter.get().toString()),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.outlined(
              onPressed: () => counters.removeAt(index),
              isSelected: false,
              icon: const Icon(Icons.delete),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => CounterScreen(index: index),
            ),
          );
        },
      ),
    );
  }
}
