# Functional lenses for Dart

> Developing a Flutter app with BLoC? Check out the [`bloc_lens`](https://pub.dev/packages/bloc_lens)
> package for a more convenient way to manage complex app states!

## Rationale

Sometimes, you want to allow other parts of your application to read and modify
a certain value, but you don't want to expose the entire object or its internals.

In short, you want two operations:
- get the current value
- set a new value

This is where lenses come in. They encapsulate the value and provide a way to
read and modify it, without exposing the object itself. THey are also composable,
so you can easily modify e.g. a specific item in a list or an entry in a map.

## Usage

### Predefined lenses

This package provides a basic implementation of the `Lens` interface, called `DirectLens`.
It allows you to combine a _getter_ and a _setter_ into a single object.

```dart
final lens = DirectLens(
  get: () => /* get the value */,
  set: (value) => /* set the value */,
);
```

Then, this object can be passed around and used to read and modify the value.

### Specialized lenses

Aside from the standard `Lens` class, this package also offers more specializes classes,
which provide additional utility methods:

- `NumberLens` – for (possibly bounded) numeric values.

  Configurable with optional minimum and maximum values, and an increment.
  Adds two methods: `increment` and `decrement`.

  ```dart
  NumberLens<int> lens;
  lens.get(); // 42
  lens.increment(); // 43
  lens.decrement(5); // 38
  ```

- `BoolLens` – for boolean values.

  Adds a `toggle` method.

  ```dart
  BoolLens lens;
  lens.get();    // true
  lens.toggle(); // false
  ```

- `EnumLens` – for enumerable values. Not just for actual `enum`s, but for
  any type that has a finite number of values.

  Adds a `next` method, which cycles through the values.

  ```dart
  MyEnum { a, b, c }
  EnumLens<MyEnum> lens;
  lens.get();  // MyEnum.a
  lens.next(); // MyEnum.b
  ```

- `ListLens` – for lists of values.

  Adds methods for adding, removing, and modifying elements. It also provides
  a way to "look deeper" and get a lens for a specific element of the list.

  ```dart
  ListLens<int> lens;
  lens.get(); // [1, 2, 3]
  lens.add(4); // [1, 2, 3, 4]
  lens.removeAt(1); // [1, 3, 4]
  lens[1].set(100); // [1, 100, 4]
  ```

- `MapLens` – for maps of values.

  Adds methods for adding, removing, and modifying specific entries, as well as
  modifying all entries at once.

  ```dart
  MapLens<String, int> lens;
  lens.get(); // {'a': 1, 'b': 2}
  lens.updateAll((key, value) => value * 2); // {'a': 2, 'b': 4}
  lens['a'].set(42); // {'a': 42, 'b': 4}
  lens['c'].set(3); // {'a': 42, 'b': 4, 'c': 3}
  lens['b'].remove(); // {'a': 42, 'c': 3}
  ```

---

<p align="center">
   <a href="https://leancode.co/?utm_source=readme&utm_medium=lens_base_package">
      <img alt="LeanCode" src="https://leancodepublic.blob.core.windows.net/public/wide.png" width="300"/>
   </a>
   <p align="center">
   Built with ☕️ by <a href="https://leancode.co/?utm_source=readme&utm_medium=lens_base_package">LeanCode</a>
   </p>
</p>
