import 'package:bloc/bloc.dart';

import 'bloc_lens.dart';

/// Utility methods to create [BlocLens]es focused on a current [BlocBase] instance.
extension BlocLensX<S> on BlocBase<S> {
  /// Creates a [BlocLens] focused on the current [BlocBase] instance.
  BlocLens<S, T> lens<T>({
    required BlocGetter<S, T> get,
    required BlocSetter<S, T> set,
  }) =>
      BlocLens(this, get, set);

  /// Creates a [BlocEnumLens] focused on the current [BlocBase] instance.
  BlocEnumLens<S, T> enumLens<T>({
    required BlocGetter<S, T> get,
    required BlocSetter<S, T> set,
    required List<T> values,
  }) =>
      BlocEnumLens(this, get, set, values);

  /// Creates a [BlocBooleanLens] focused on the current [BlocBase] instance.
  BlocBooleanLens<S> boolLens({
    required BlocGetter<S, bool> get,
    required BlocSetter<S, bool> set,
  }) =>
      BlocBooleanLens(this, get, set);

  /// Creates a [BlocListLens] focused on the current [BlocBase] instance.
  BlocListLens<S, T> listLens<T>({
    required BlocGetter<S, List<T>> get,
    required BlocSetter<S, List<T>> set,
  }) =>
      BlocListLens(this, get, set);

  /// Creates a [BlocMapLens] focused on the current [BlocBase] instance.
  BlocMapLens<S, K, V> mapLens<K, V extends Object>({
    required BlocGetter<S, Map<K, V>> get,
    required BlocSetter<S, Map<K, V>> set,
  }) =>
      BlocMapLens(this, get, set);

  /// Creates a [BlocNumberLens] focused on the current [BlocBase] instance.
  BlocNumberLens<S, T> numberLens<T extends num>({
    required BlocGetter<S, T> get,
    required BlocSetter<S, T> set,
    T? min,
    T? max,
    T? step,
  }) =>
      BlocNumberLens(
        this,
        get,
        set,
        min: min,
        max: max,
        step: step,
      );
}
