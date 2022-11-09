// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testing_bloc_course/api/login_api.dart';
import 'package:testing_bloc_course/api/notes_api.dart';
import 'package:testing_bloc_course/bloc/app_bloc.dart';
import 'package:testing_bloc_course/models.dart';

const Iterable<Note> _mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handleToReturn,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandle.fooBar();

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    } else {
      return null;
    }
  }
}

const acceptedLoginHandle = LoginHandle(token: 'ABC');

void main() {
  blocTest<AppBloc, AppState>(
    'Initial test of the app should be AppState.empty()',
    build: () => AppBloc(
      loginApi: const DummyLoginApi.empty(),
      notesApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    verify: (appState) => expect(appState.state, const AppState.empty()),
  );

  blocTest<AppBloc, AppState>(
    'Can we in with the correct credentials?',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
          acceptedEmail: 'foo@bar.com',
          acceptedPassword: 'foobar',
          handleToReturn: acceptedLoginHandle),
      notesApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (bloc) => bloc.add(
      const LoginEvent(email: 'foo@bar.com', password: 'foobar'),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      )
    ],
  );

  blocTest<AppBloc, AppState>(
    'We should not be able to log in with the incorrect credentials',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
          acceptedEmail: 'foo@bar.com',
          acceptedPassword: 'foobar',
          handleToReturn: acceptedLoginHandle),
      notesApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (bloc) => bloc.add(
      const LoginEvent(email: 'bar@bar.com', password: 'foobar'),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
      ),
      const AppState(
        isLoading: false,
        loginError: LoginErrors.invalidHandle,
        loginHandle: null,
        fetchedNotes: null,
      )
    ],
  );

  blocTest<AppBloc, AppState>(
    'Can we fetch notes after log in',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
          acceptedEmail: 'foo@bar.com',
          acceptedPassword: 'foobar',
          handleToReturn: acceptedLoginHandle),
      notesApi: const DummyNotesApi(
          acceptedLoginHandle: acceptedLoginHandle,
          notesToReturnForAcceptedLoginHandle: _mockNotes),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (bloc) {
      bloc.add(
        const LoginEvent(email: 'foo@bar.com', password: 'foobar'),
      );
      bloc.add(
        const LoadNotesEvent(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: true,
        loginHandle: acceptedLoginHandle,
      ),
      const AppState(
          isLoading: false,
          loginHandle: acceptedLoginHandle,
          fetchedNotes: _mockNotes),
    ],
  );
}
