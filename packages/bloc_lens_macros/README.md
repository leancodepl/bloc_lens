# Macros for bloc_lens (experimental 🧪)

This package provides macros to simplify the use of the [`bloc_lens`][bloc_lens] package.

# Motivation

The `bloc_lens` package simplifies working with large blocs. But in order to use it,
you have to create a lens for every field in the state. The `MakeLenses` macro reads
properties of the state class and generates lenses for them, taking into account types
of each field.

## Before

```dart
class SettingsCubit extends Cubit<SettingsState> {
  late final scaling = numberLens(
    get: (s) => s.scaling,
    set: (s, v) => s.copyWith(scaling: v),
    min: 0.7,
    max: 1.4,
    step: 0.1,
  );

  late final hapticFeedback = boolLens(
    get: (s) => s.hapticFeedback,
    set: (s, v) => s.copyWith(hapticFeedback: v),
  );

  late final showGrid = boolLens(
    get: (s) => s.showGrid,
    set: (s, v) => s.copyWith(showGrid: v),
  );
  
  late final themeMode = enumLens(
    get: (s) => s.themeMode,
    set: (s, v) => s.copyWith(themeMode: v),
    values: ThemeMode.values,
  );
  
  late final locale = lens(
    get: (s) => s.locale,
    set: (s, v) => s.copyWith(locale: v),
  );
}

class SettingsState {
  const SettingsState({
    required this.scaling,
    required this.hapticFeedback,
    required this.showGrid,
    required this.themeMode,
    required this.locale,
  });

  final double scaling;
  final bool hapticFeedback;
  final bool showGrid;
  final ThemeMode themeMode;
  final Locale locale;
}
```

## After

```dart
@MakeLenses()
class SettingsCubit extends Cubit<SettingsState> {
}

class SettingsState {
  const SettingsState({
    required this.scaling,
    required this.hapticFeedback,
    required this.showGrid,
    required this.themeMode,
    required this.locale,
  });

  @NumberOptions(min: 0.7, max: 1.4, step: 0.1)
  final double scaling;
  final bool hapticFeedback;
  final bool showGrid;
  final ThemeMode themeMode;
  final Locale locale;
}
```

---

<p align="center">
   <a href="https://leancode.co/?utm_source=readme&utm_medium=bloc_lens_package">
      <img alt="LeanCode" src="https://leancodepublic.blob.core.windows.net/public/wide.png" width="300"/>
   </a>
   <p align="center">
   Built with ☕️ by <a href="https://leancode.co/?utm_source=readme&utm_medium=bloc_lens_package">LeanCode</a>
   </p>
</p>

[bloc_lens]: https://pub.dev/packages/bloc_lens
