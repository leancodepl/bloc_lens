import 'package:bloc_lens/bloc_lens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountersCubit extends Cubit<CountersState> {
  CountersCubit() : super(const CountersState(counters: [0]));

  late final counters = listLens(
    get: (s) => s.counters,
    set: (s, v) => CountersState(counters: v),
  );
}

class CountersState {
  const CountersState({
    required this.counters,
  });

  final List<int> counters;
}
