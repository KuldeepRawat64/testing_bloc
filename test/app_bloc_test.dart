import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_bloc_course/bloc/app_bloc.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Bar'.toUint8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'Testing the initial state of the app',
    build: () => AppBloc(urls: []),
    verify: (bloc) => expect(
      bloc.state,
      const AppState.empty(),
    ),
  );

  // load valid data and compare states
  blocTest<AppBloc, AppState>(
    'test the ability to load a url',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (bloc) => bloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(isLoading: true),
      AppState(isLoading: false, data: text1Data),
    ],
  );

  blocTest<AppBloc, AppState>(
    'throw an error in url loader and catch it',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (bloc) => bloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(isLoading: true),
      const AppState(isLoading: false, error: Errors.dummy),
    ],
  );
  blocTest<AppBloc, AppState>(
    'test the ability to load more than one url',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2Data),
    ),
    act: (bloc) => [
      bloc.add(
        const LoadNextUrlEvent(),
      ),
      bloc.add(
        const LoadNextUrlEvent(),
      ),
    ],
    expect: () => [
      const AppState(isLoading: true),
      AppState(isLoading: false, data: text2Data),
      const AppState(isLoading: true),
      AppState(isLoading: false, data: text2Data),
    ],
  );
}
