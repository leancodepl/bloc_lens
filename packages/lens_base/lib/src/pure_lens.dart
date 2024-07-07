import 'package:meta/meta.dart';

/// Signature for a getter-like functions.
typedef PureGetter<S, T> = T Function(S);

/// Signature for a setter-like functions.
typedef PureSetter<S, T> = S Function(S, T);

/// A [PureLens] object manages a value by providing [get] and [set] methods.
abstract class PureLens<S, T> {
  /// Returns the value managed by this lens.
  @useResult
  T get(S state);

  /// Sets the value managed by this lens.
  @useResult
  S set(S state, T value);
}

/// An [PureEnumLens] extends a standard [PureLens] by allowing to cycle through
/// a list of allowed values. [next] sets values in the order they
/// are provided in [values].
abstract mixin class PureEnumLens<S, T> implements PureLens<S, T> {
  /// The list of allowed values for this lens.
  List<T> get values;

  /// Cycles to the next value in [values].
  @useResult
  S next(S state) => set(state, values[(index(state) + 1) % values.length]);

  /// Index of the current value in [values].
  @useResult
  int index(S state) => values.indexOf(get(state));
}

/// A [PureBoolLens] extends a standard [PureLens] with boolean-specific operations.
abstract mixin class PureBoolLens<S> implements PureLens<S, bool> {
  /// Toggles the value of this lens.
  @useResult
  S toggle(S state) => set(state, !get(state));
}

/// A [PureNumberLens] extends a standard [PureLens] with operations on a target number.
abstract mixin class PureNumberLens<S, T extends num>
    implements PureLens<S, T> {
  /// An optional lower bound for the value managed by this lens.
  T? get min;

  /// An optional upper bound for the value managed by this lens.
  T? get max;

  /// An optional step for incrementing and decrementing the value managed by this lens.
  T? get step;

  T _clamp(T value) {
    if (min case final min? when value < min) {
      return min;
    }

    if (max case final max? when value > max) {
      return max;
    }

    return value;
  }

  /// Increments the value managed by this lens by [step]. If [step] is not provided,
  /// the value of [PureNumberLens.step] is used, or 1.
  @useResult
  S increment(S state, [T? step]) {
    final actualStep = step ?? this.step ?? 1;

    return set(state, _clamp(get(state) + actualStep as T));
  }

  /// Decrements the value managed by this lens by [step]. If [step] is not provided,
  /// the value of [PureNumberLens.step] is used, or 1.
  @useResult
  S decrement(S state, [T? step]) {
    final actualStep = step ?? this.step ?? 1;

    return set(state, _clamp(get(state) - actualStep as T));
  }
}

/// A [PureListLens] extends a standard [PureLens] with operations on a target list.
/// It also provides a lens focused on a specific element of the list.
abstract mixin class PureListLens<S, T extends Object>
    implements PureLens<S, List<T>> {
  /// Adds an element to the list managed by this lens.
  @useResult
  S add(S state, T element) => set(state, [...get(state), element]);

  /// Adds all elements to the list managed by this lens.
  @useResult
  S addAll(S state, Iterable<T> elements) =>
      set(state, [...get(state), ...elements]);

  /// Removes an element from the list managed by this lens.
  @useResult
  S remove(S state, T element) => set(state, [...get(state)]..remove(element));

  /// Removes an element at a specific index from the list managed by this lens.
  @useResult
  S removeAt(S state, int index) =>
      set(state, [...get(state)]..removeAt(index));

  /// Removes all elements from the list managed by this lens.
  @useResult
  S removeAll(S state, Iterable<T> elements) =>
      set(state, [...get(state)]..removeWhere(elements.contains));

  /// Toggles an element in the list managed by this lens.
  /// If the element is in the list, it is removed. Otherwise, it is added.
  @useResult
  S toggleElement(S state, T element) {
    if (contains(state, element)) {
      return remove(state, element);
    } else {
      return add(state, element);
    }
  }

  /// Whether the list managed by this lens contains the provided element.
  @useResult
  bool contains(S state, T element) => get(state).contains(element);

  /// Returns a lens focused on a specific index of the list, if the index
  /// is within the bounds of the list.
  @useResult
  PureIndexLens<S, T> operator [](int index) => PureIndexLens(this, index);
}

/// An [PureIndexLens] manages a value at a specific index of a list.
/// Uses a [PureListLens] as a parent lens.
class PureIndexLens<S, T extends Object> extends PureLens<S, T?> {
  /// Creates a new [PureIndexLens] with a parent [PureListLens] and an index.
  PureIndexLens(
    this.listLens,
    this.index,
  );

  /// The parent lens managing the list.
  final PureListLens<S, T> listLens;

  /// The index of the element in the list.
  final int index;

  @override
  @useResult
  T? get(S state) => listLens.get(state).elementAtOrNull(index);

  @override
  @useResult
  S set(S state, covariant T value) =>
      listLens.set(state, [...listLens.get(state)]..[index] = value);
}

/// A [PureMapLens] extends a standard [PureLens] with operations on a target map.
abstract mixin class PureMapLens<S, K, V extends Object>
    implements PureLens<S, Map<K, V>> {
  /// Updates all values in the map managed by this lens.
  @useResult
  S updateAll(S state, V Function(K key, V value) update) =>
      set(state, {...get(state)}..updateAll(update));

  /// Returns a lens focused on a specific key of the map.
  @useResult
  PureMapEntryLens<S, K, V> operator [](K key) {
    return PureMapEntryLens(this, key);
  }

  /// Returns a list of values in the map managed by this lens.
  @useResult
  Iterable<V> values(S state) => get(state).values;
}

/// A [PureMapEntryLens] extends a standard [PureLens] with operations
/// on a specific entry of a map.
class PureMapEntryLens<S, K, V extends Object> implements PureLens<S, V?> {
  /// Creates a new [PureMapEntryLens] with a parent [PureMapLens] and a [key].
  PureMapEntryLens(
    this.mapLens,
    this.key,
  );

  /// The parent lens managing the map.
  final PureMapLens<S, K, V> mapLens;

  /// The key of the entry in the map.
  final K key;

  @override
  @useResult
  V? get(S state) => mapLens.get(state)[key];

  @override
  @useResult
  S set(S state, V? value) => mapLens.set(
        state,
        switch (value) {
          final value? => {...mapLens.get(state), key: value},
          null => {...mapLens.get(state)}..remove(key),
        },
      );

  /// Removes the entry from the map managed by this lens.
  @useResult
  S remove(S state) => set(state, null);

  /// Whether the entry exists in the map managed by this lens.
  @useResult
  bool exists(S state) => get(state) != null;

  /// Updates the value of the entry in the map managed by this lens.
  /// If the entry does not exist, the value is set to the result of [ifAbsent].
  @useResult
  S update(
    S state,
    V Function(V value) update, {
    V Function()? ifAbsent,
  }) {
    if (get(state) case final value?) {
      return set(state, update(value));
    } else if (ifAbsent case final ifAbsent?) {
      return set(state, ifAbsent());
    } else {
      throw StateError('ifAbsent must be provided when value does not exist');
    }
  }
}
