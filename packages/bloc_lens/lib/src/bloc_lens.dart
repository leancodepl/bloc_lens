import 'package:bloc/bloc.dart';
import 'package:lens_base/lens_base.dart';

/// Signature for a function getting a value of type [T] from a state of type [S].
typedef BlocGetter<S, T> = T Function(S state);

/// Signature for a function updating a state of type [S] with a value of type [T].
typedef BlocSetter<S, T> = S Function(S state, T value);

/// A [BlocLens] is a way to access a part of a [BlocBase]'s state by coupling
/// a getter and setter focused on a specific bloc instance.
///
/// It can be used to get and set the value of a field in the state.
/// It automatically emits a new state when the value is set.
class BlocLens<S, T> implements Lens<T> {
  /// Creates a [BlocLens].
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

/// An adaptation of an [EnumLens] for a [BlocLens].
class BlocEnumLens<S, T> extends BlocLens<S, T> with EnumLens<T> {
  /// Creates a [BlocEnumLens].
  const BlocEnumLens(super.bloc, super.get, super.set, this.values);

  @override
  final List<T> values;
}

/// An adaptation of a [BoolLens] for a [BlocLens].
class BlocBooleanLens<S> extends BlocLens<S, bool> with BoolLens {
  /// Creates a [BlocBooleanLens].
  const BlocBooleanLens(
    super.bloc,
    super.get,
    super.set,
  );
}

/// An adaptation of a [NumberLens] for a [BlocLens].
class BlocNumberLens<S, T extends num> extends BlocLens<S, T>
    with NumberLens<T> {
  /// Creates a [BlocNumberLens].
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

/// An adaptation of a [ListLens] for a [BlocLens].
class BlocListLens<S, T> extends BlocLens<S, List<T>> with ListLens<T> {
  /// Creates a [BlocListLens].
  const BlocListLens(super.bloc, super.get, super.set);
}

/// An adaptation of a [MapLens] for a [BlocLens].
class BlocMapLens<S, K, V extends Object> extends BlocLens<S, Map<K, V>>
    with MapLens<K, V> {
  /// Creates a [BlocMapLens].
  const BlocMapLens(
    super.bloc,
    super.get,
    super.set,
  );
}
