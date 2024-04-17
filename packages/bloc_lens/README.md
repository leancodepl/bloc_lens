# bloc_lens

This package provides a set of bloc-specific classes, made to work with the [`lens_base`][lens_base] package.

## Example usage

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
  
  late final themeMode = enumLens(
    get: (s) => s.themeMode,
    set: (s, v) => s.copyWith(themeMode: v),
    values: ThemeMode.values,
  );
}

class SettingsState {
  const SettingsState({
    required this.scaling,
    required this.hapticFeedback,
    required this.themeMode,
  });

  final double scaling;
  final bool hapticFeedback;
  final ThemeMode themeMode;
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

[lens_base]: https://pub.dev/packages/lens_base
