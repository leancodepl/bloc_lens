# Functional lenses for Dart

## Usage

### Basic methods

```dart
LensBase<int> lens;

void main() {
  // Get the value:
  lens.get(); // 42

  // Set the value:
  lens.set(100);
  lens.get(); // 100
}
```

### Specialized methods

```dart
NumberLens<int> numberLens;
BoolLens boolLens;
EnumLens<MyEnum> enumLens;
ListLent<int> listLens;

void main() {
  // Numbers:
  numberLens.get(); // 42
  numberLens.increment();
  numberLens.get(); // 43
  
  // Booleans:
  boolLens.get(); // true
  boolLens.toggle();
  boolLens.get(); // false

  // Enums:
  enumLens.get(); // MyEnum.value1
  enumLens.next();
  enumLens.get(); // MyEnum.value2
  
  // Lists:
  listLens.get(); // [1, 2, 3]
  listLens.add(4);
  listLens.get(); // [1, 2, 3, 4]
  listLens.at(1).set(100);
  listLens.get(); // [1, 100, 3, 4]
}
```
