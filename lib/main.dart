import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:testing_bloc_course/logic/cubit/random_name_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => RandomNameCubit(),
        child: const MyHomePage(),
      ),
    );
  }
}

List<String> names = [
  'Foo',
  'bar',
  'Nav',
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: BlocListener<RandomNameCubit, RandomNameState>(
          bloc: context.watch<RandomNameCubit>(),
          child: Text('Random Name : $name'),
          listener: (context, state) {
            if (state.name.isNotEmpty) {
              name = state.name;
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<RandomNameCubit>().pickRandomName();
        },
        tooltip: 'Random Name',
        child: const Icon(Icons.search),
      ),
    );
  }
}
