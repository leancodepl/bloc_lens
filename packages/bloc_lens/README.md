# Functional lenses for Dart & BLoC

To read the basic documentation & the rationale, please visit
the [lens_base](https://pub.dev/packages/lens_base) package.

This package provides a set of BLoC-specific classes and extensions.

## Usage

Let's say you have a BLoC with many properties, and you want an easy way to
modify these values independently. Normally, you would have to create separate
methods for each property, like this:
```dart
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void setScaling(double scaling) {
    emit(state.copyWith(scaling: scaling));
  }

  void setHapticFeedback(bool hapticFeedback) {
    emit(state.copyWith(hapticFeedback: hapticFeedback));
  }

  void setThemeMode(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
  }

  void setLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  void setFontSize(double fontSize) {
    emit(state.copyWith(fontSize: fontSize));
  }
}

class SettingsState {
  const SettingsState({
    required this.scaling,
    required this.hapticFeedback,
    required this.themeMode,
    required this.locale,
    required this.fontSize,
  });

  final double scaling;
  final bool hapticFeedback;
  final ThemeMode themeMode;
  final Locale locale;
  final double fontSize;
}
```

But that separates the `getter` and `setter` for each property, which forces you
to pass around the current value, the way to change it, and possibly some more
information (like the list of allowed values, or the allowed range). With lenses,
you have one object that fully manages the value, together with its constraints:

<table>
<tr><th>❌ Without lenses</th><th>✅ With lenses</th></tr>
<tr>
<td valign="top">

```dart
class MySlider extends StatelessWidget {
  const MySlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
  });
  
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    ...
  }
}
```

</td>
<td valign="top">

```dart
class MySlider extends StatelessWidget {
  const MySlider({
    super.key,
    required this.lens,
  });
  
  final NumberLens<double> lens;

  @override
  Widget build(BuildContext context) {
    ...
  }
}
```

</td>
</tr>
</table>

To define lenses inside BLoCs, you can use the extensions provided by this package:

```dart
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  late final scaling = numberLens(
    get: () => state.scaling,
    set: (value) => state.copyWith(scaling: value),
    min: 0.5,
    max: 2.0,
    increment: 0.1,
  );

  late final themeMode = enumLens(
    get: () => state.themeMode,
    set: (value) => state.copyWith(themeMode: value),
    values: ThemeMode.values,
  );
  
  ...
}
```

You can then use these inside your widgets:
```dart
Widget build(BuildContext context) {
  final cubit = context.watch<SettingsCubit>();

  return MySlider(
    lens: cubit.scaling,
  );
}
```

If you're also using `flutter_hooks`, you can include in your project a hook that
combines finding the bloc and listening to the specific changes:
```dart
@optionalTypeArgs
L useBlocLens<B extends BlocBase<S>, S, L extends BlocLens<S, T>, T>(
  L Function(B cubit) lensGetter, {
  bool listen = true,
}) {
  final cubit = useContext().read<B>();
  final lens = lensGetter(cubit);
  useStream(
    listen ? cubit.stream.map((_) => lens.get()).distinct() : null,
  );
  return lens;
}
```

```dart
Widget build(BuildContext context) {
  final scaling = useBlocLens((SettingsCubit cubit) => cubit.scaling);

  return MySlider(
    lens: scaling,
  );
}
```

Please note, that this hook is not provided out-of-the-box in the package
to keep the dependencies Flutter-less.

For an example of how to use lenses in a sample Flutter app, check out the
[example app](./example/bloc_lens_example/lib/features/counters_cubit.dart).

<br/>

> ### 🧪 **Experimental**
>
> If you want to preview an even easier way of using lenses inside BLoCs without any boilerplate,
> check out the [`bloc_lens_macros`](https://pub.dev/packages/bloc_lens_macros) package.

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
