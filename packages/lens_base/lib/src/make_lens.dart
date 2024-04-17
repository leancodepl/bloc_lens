import 'lens.dart';

class _BoolLens extends BoolLens {
  _BoolLens(this._get, this._set);

  final Getter<bool> _get;
  final Setter<bool> _set;

  @override
  bool get() => _get();

  @override
  void set(bool value) => _set(value);
}

/// Creates a [BoolLens] with the provided [get] and [set] functions.
BoolLens makeBoolLens({
  required Getter<bool> get,
  required Setter<bool> set,
}) =>
    _BoolLens(get, set);

class _EnumLens<T> extends EnumLens<T> {
  _EnumLens(this._get, this._set, this.values);

  final Getter<T> _get;
  final Setter<T> _set;

  @override
  T get() => _get();

  @override
  void set(T value) => _set(value);

  @override
  final List<T> values;
}

/// Creates an [EnumLens] with the provided [get], [set], and [values].
EnumLens<T> makeEnumLens<T>({
  required Getter<T> get,
  required Setter<T> set,
  required List<T> values,
}) =>
    _EnumLens(get, set, values);
