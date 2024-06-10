import 'package:bloc_lens_example/features/counters_cubit.dart';
import 'package:bloc_lens_example/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CountersCubit(),
      child: MaterialApp(
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00FF00),
            dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
            brightness: Brightness.dark,
          ),
        ),
        home: const Home(),
      ),
    );
  }
}
