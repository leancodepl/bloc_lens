/// Signature for a getter-like functions.
typedef Getter<T> = T Function();

/// Signature for a setter-like functions.
typedef Setter<T> = void Function(T value);

/// A [LensBase] object manages a value by providing [get] and [set] methods.
abstract class LensBase<T> {
  /// Returns the value managed by this lens.
  T get();

  /// Sets the value managed by this lens.
  void set(T value);
}

/// An [EnumLens] extends a standard [LensBase] by allowing to cycle through
/// a list of allowed values. [next] sets values in the order they
/// are provided in [values].
abstract mixin class EnumLens<T> implements LensBase<T> {
  /// The list of allowed values for this lens.
  List<T> get values;

  /// Cycles to the next value in [values].
  void next() {
    set(values[(index + 1) % values.length]);
  }

  /// Index of the current value in [values].
  int get index => values.indexOf(get());
}

/// A [BoolLens] extends a standard [LensBase] with boolean-specific operations.
abstract mixin class BoolLens implements LensBase<bool> {
  /// Toggles the value of this lens.
  void toggle() => set(!get());
}

/// A [NumberLens] extends a standard [LensBase] with operations on a target number.
abstract mixin class NumberLens<T extends num> implements LensBase<T> {
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
  /// the value of [NumberLens.step] is used.
  void increment([T? step]) {
    final actualStep = step ?? this.step!;

    set(_clamp(get() + actualStep as T));
  }

  /// Decrements the value managed by this lens by [step]. If [step] is not provided,
  /// the value of [NumberLens.step] is used.
  void decrement([T? step]) {
    final actualStep = step ?? this.step!;

    set(_clamp(get() - actualStep as T));
  }
}

/// A [ListLens] extends a standard [LensBase] with operations on a target list.
/// It also provides a lens focused on a specific element of the list.
abstract mixin class ListLens<T> implements LensBase<List<T>> {
  /// Adds an element to the list managed by this lens.
  void add(T element) {
    set([...get(), element]);
  }

  /// Adds all elements to the list managed by this lens.
  void addAll(Iterable<T> elements) {
    set([...get(), ...elements]);
  }

  /// Removes an element from the list managed by this lens.
  void remove(T element) {
    set([...get()]..remove(element));
  }

  /// Removes an element at a specific index from the list managed by this lens.
  void removeAt(int index) {
    set([...get()]..removeAt(index));
  }

  /// Removes all elements from the list managed by this lens.
  void removeAll(Iterable<T> elements) {
    set([...get()]..removeWhere((e) => elements.contains(e)));
  }

  /// Toggles an element in the list managed by this lens.
  /// If the element is in the list, it is removed. Otherwise, it is added.
  void toggleElement(T element) {
    if (contains(element)) {
      remove(element);
    } else {
      add(element);
    }
  }

  /// Whether the list managed by this lens contains the provided element.
  bool contains(T element) => get().contains(element);

  /// Returns a lens focused on a specific index of the list, if the index
  /// is within the bounds of the list.
  IxLens<T>? at(int index) => index < get().length ? IxLens(this, index) : null;
}

/// An [IxLens] manages a value at a specific index of a list.
/// Uses a [ListLens] as a parent lens.
class IxLens<T> extends LensBase<T> {
  /// Creates a new [IxLens] with a parent [ListLens] and an index.
  IxLens(
    this.listLens,
    this.index,
  );

  /// The parent lens managing the list.
  final ListLens<T> listLens;

  /// The index of the element in the list.
  final int index;

  @override
  T get() => listLens.get()[index];

  @override
  void set(T value) => listLens.set([...listLens.get()]..[index] = value);
}

/// A [MapLens] extends a standard [LensBase] with operations on a target map.
abstract mixin class MapLens<K, V extends Object>
    implements LensBase<Map<K, V>> {
  /// Updates all values in the map managed by this lens.
  void updateAll(V Function(K key, V value) update) {
    set({...get()}..updateAll(update));
  }

  /// Returns a lens focused on a specific key of the map.
  MapEntryLens<K, V> operator [](K key) {
    return MapEntryLens(this, key);
  }

  /// Returns a list of values in the map managed by this lens.
  Iterable<V> get values => get().values;
}

/// A [MapEntryLens] extends a standard [LensBase] with operations
/// on a specific entry of a map.
class MapEntryLens<K, V extends Object> implements LensBase<V?> {
  /// Creates a new [MapEntryLens] with a parent [MapLens] and a [key].
  MapEntryLens(
    this.mapLens,
    this.key,
  );

  /// The parent lens managing the map.
  final MapLens<K, V> mapLens;

  /// The key of the entry in the map.
  final K key;

  @override
  V? get() => mapLens.get()[key];

  @override
  void set(V? value) => mapLens.set(
        switch (value) {
          final value? => {...mapLens.get(), key: value},
          null => {...mapLens.get()}..remove(key),
        },
      );

  /// Removes the entry from the map managed by this lens.
  void remove() => set(null);

  /// Whether the entry exists in the map managed by this lens.
  bool get exists => get() != null;

  /// Updates the value of the entry in the map managed by this lens.
  /// If the entry does not exist, the value is set to the result of [ifAbsent].
  void update(
    V Function(V value) update, {
    V Function()? ifAbsent,
  }) {
    if (get() case final value?) {
      set(update(value));
    } else if (ifAbsent case final ifAbsent?) {
      set(ifAbsent());
    } else {
      throw StateError('ifAbsent must be provided when value does not exist');
    }
  }
}
