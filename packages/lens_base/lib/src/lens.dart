typedef Getter<T> = T Function();
typedef Setter<T> = void Function(T value);

/// A [LensBase] object manages a value by providing [get] and [set] methods.
abstract class LensBase<T> {
  T get();

  void set(T value);
}

/// An [EnumLens] extends a standard [LensBase] by allowing to cycle through
/// a list of allowed values. [next] sets values in the order they
/// are provided in [values].
abstract mixin class EnumLens<T> implements LensBase<T> {
  List<T> get values;

  void next() {
    set(values[(index + 1) % values.length]);
  }

  int get index => values.indexOf(get());
}

abstract mixin class BoolLens implements LensBase<bool> {
  void toggle() => set(!get());
}

abstract mixin class NumberLens<T extends num> implements LensBase<T> {
  T? get min;

  T? get max;

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

  void increment([T? step]) {
    assert(step != null || this.step != null);
    final actualStep = step ?? this.step!;

    set(_clamp(get() + actualStep as T));
  }

  void decrement([T? step]) {
    assert(step != null || this.step != null);
    final actualStep = step ?? this.step!;

    set(_clamp(get() - actualStep as T));
  }
}

/// A [ListLens] extends a standard [LensBase] with operations on a target list.
/// It also provides a lens focused on a specific element of the list.
abstract mixin class ListLens<T> implements LensBase<List<T>> {
  void addElement(T element) {
    set([...get(), element]);
  }

  void addAllElements(Iterable<T> elements) {
    set([...get(), ...elements]);
  }

  void removeElement(T element) {
    set([...get()]..remove(element));
  }

  void removeAllElements(Iterable<T> elements) {
    set([...get()]..removeWhere((e) => elements.contains(e)));
  }

  void toggleListElement(T element) {
    if (contains(element)) {
      removeElement(element);
    } else {
      addElement(element);
    }
  }

  bool contains(T element) => get().contains(element);

  LensBase<T> at(int index) => IxLens(this, index);
}

class IxLens<T> extends LensBase<T> {
  IxLens(
    this.listLens,
    this.index,
  );

  final ListLens<T> listLens;
  final int index;

  @override
  T get() => listLens.get()[index];

  @override
  void set(T value) => listLens.set([...listLens.get()]..[index] = value);
}

/// A [MapLens] extends a standard [LensBase] with operations on a target map.
abstract mixin class MapLens<K, V extends Object>
    implements LensBase<Map<K, V>> {
  void updateAll(V Function(K key, V value) update) {
    set({...get()}..updateAll(update));
  }

  /// Returns a lens focused on a specific key of the map.
  MapEntryLens<K, V> operator [](K key) {
    return MapEntryLens(this, key);
  }

  Iterable<V> get values => get().values;
}

/// A [MapEntryLens] extends a standard [LensBase] with operations
/// on a specific entry of a map.
class MapEntryLens<K, V extends Object> implements LensBase<V?> {
  MapEntryLens(
    this.mapLens,
    this.key,
  );

  final MapLens<K, V> mapLens;
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

  void remove() => set(null);

  bool get exists => get() != null;

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
