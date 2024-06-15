import 'package:bloc/bloc.dart';
import 'package:bloc_lens/bloc_lens.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

/// A hook that listens to a bloc and returns a lens that reads from and writes to the bloc's state.
/// If [listen] is true, the widget rebuilds when the value managed by the lens changes.
@optionalTypeArgs
L useBlocLens<B extends BlocBase<S>, S, L extends BlocLens<S, T>, T>(
  L Function(B cubit) lensGetter, {
  bool listen = true,
}) {
  final cubit = useContext().read<B>();
  final lens = lensGetter(cubit);
  useStream(
    listen ? cubit.stream.map((_) => lens.get()).distinct() : null,
  );
  return lens;
}
