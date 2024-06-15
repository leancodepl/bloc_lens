import 'lens.dart';

/// {@template direct_lens}
/// A lens backed by explicitly provided getter and setter functions.
/// {@endtemplate}
class DirectLens<T> extends Lens<T> {
  /// {@macro direct_lens}
  DirectLens({
    required Getter<T> get,
    required Setter<T> set,
  })  : _get = get,
        _set = set;

  final Getter<T> _get;
  final Setter<T> _set;

  @override
  T get() => _get();

  @override
  void set(T value) => _set(value);
}

/// {@template direct_bool_lens}
/// A boolean lens backed by explicitly provided getter and setter functions.
/// {@endtemplate}
class DirectBoolLens extends DirectLens<bool> with BoolLens {
  /// {@macro direct_bool_lens}
  DirectBoolLens({required super.get, required super.set});
}

/// {@template direct_enum_lens}
/// An enum lens backed by explicitly provided getter and setter functions.
/// {@endtemplate}
class DirectEnumLens<T> extends DirectLens<T> with EnumLens<T> {
  /// {@macro direct_enum_lens}
  DirectEnumLens({
    required super.get,
    required super.set,
    required this.values,
  });

  @override
  final List<T> values;
}

/// {@template direct_number_lens}
/// A number lens backed by explicitly provided getter and setter functions.
/// {@endtemplate}
class DirectNumberLens<T extends num> extends DirectLens<T> with NumberLens<T> {
  /// {@macro direct_number_lens}
  DirectNumberLens({
    required super.get,
    required super.set,
    required this.min,
    required this.max,
    required this.step,
  });

  @override
  final T? min;
  @override
  final T? max;
  @override
  final T? step;
}

/// {@template direct_list_lens}
/// A list lens backed by explicitly provided getter and setter functions.
/// {@endtemplate}
class DirectListLens<T> extends DirectLens<List<T>> with ListLens<T> {
  /// {@macro direct_list_lens}
  DirectListLens({required super.get, required super.set});
}

/// {@template direct_map_lens}
/// A map lens backed by explicitly provided getter and setter functions.
/// {@endtemplate}
class DirectMapLens<K, V extends Object> extends DirectLens<Map<K, V>>
    with MapLens<K, V> {
  /// {@macro direct_map_lens}
  DirectMapLens({required super.get, required super.set});
}
