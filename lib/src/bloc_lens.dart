import 'package:bloc/bloc.dart';

import 'lens.dart';

typedef BlocGetter<S, T> = T Function(S state);
typedef BlocSetter<S, T> = S Function(S state, T value);

/// A [BlocLens] is a way to access a part of a [BlocBase]'s state by coupling
/// a getter and setter focused on a specific bloc instance.
///
/// It can be used to get and set the value of a field in the state.
/// It automatically emits a new state when the value is set.
class BlocLens<S, T> implements LensBase<T> {
  const BlocLens(this._bloc, this._get, this._set);

  void _emit(S state) {
    if (!_bloc.isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      _bloc.emit(state);
    }
  }

  final BlocBase<S> _bloc;
  final BlocGetter<S, T> _get;
  final BlocSetter<S, T> _set;

  @override
  void set(T value) => _emit(_set(_bloc.state, value));

  @override
  T get() => _get(_bloc.state);
}

/// A [BlocLens] that can be used to cycle through a list of values.
class BlocEnumLens<S, T> extends BlocLens<S, T> with EnumLens<T> {
  const BlocEnumLens(super.bloc, super.get, super.set, this.values);

  @override
  final List<T> values;
}

class BlocBooleanLens<S> extends BlocLens<S, bool> with BoolLens {
  const BlocBooleanLens(
    super.bloc,
    super.get,
    super.set,
  );
}

class BlocNumberLens<S, T extends num> extends BlocLens<S, T>
    with NumberLens<T> {
  const BlocNumberLens(
    super.bloc,
    super.get,
    super.set, {
    this.min,
    this.max,
    this.step,
  });

  @override
  final T? min;

  @override
  final T? max;

  @override
  final T? step;
}

/// A [BlocLens] that can be used to manage a list of values.
class BlocListLens<S, T> extends BlocLens<S, List<T>> with ListLens<T> {
  const BlocListLens(super.bloc, super.get, super.set);
}

/// A [BlocLens] that can be used to manage a map of values.
class BlocMapLens<S, K, V extends Object> extends BlocLens<S, Map<K, V>>
    with MapLens<K, V> {
  const BlocMapLens(
    super.bloc,
    super.get,
    super.set,
  );
}
