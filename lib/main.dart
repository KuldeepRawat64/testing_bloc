import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/logic/bloc/person_bloc.dart';
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
        create: (_) => RandomNameCubit(),
        child: BlocProvider(
          create: (_) => PersonBloc(),
          child: const MyHomePage(),
        ),
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

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

enum PersonUrl {
  persons1,
  persons2,
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.persons1:
        return 'http://127.0.0.1:5500/api/persons1.json';
      case PersonUrl.persons2:
        return 'http://127.0.0.1:5500/api/persons2.json';
    }
  }
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
        body: Column(
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      context
                          .read<PersonBloc>()
                          .add(const LoadPersonEvent(url: PersonUrl.persons1));
                    },
                    child: const Text('Load json #1')),
                TextButton(
                    onPressed: () {
                      context
                          .read<PersonBloc>()
                          .add(const LoadPersonEvent(url: PersonUrl.persons2));
                    },
                    child: const Text('Load json #2')),
              ],
            ),
            BlocBuilder<PersonBloc, PersonFetched?>(
              buildWhen: (previousResult, currentResult) {
                return previousResult?.persons != currentResult?.persons;
              },
              builder: (context, personFetched) {
                log('${personFetched?.toString()}');
                final persons = personFetched?.persons;
                if (persons == null) {
                  return const SizedBox.shrink();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: persons.length,
                    itemBuilder: (BuildContext context, int index) {
                      final person = persons[index]!;
                      return ListTile(
                        title: Text(person.name),
                        subtitle: Text((person.age).toString()),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ));
  }
}
