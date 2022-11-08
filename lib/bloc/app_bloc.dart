// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:testing_bloc_course/api/login_api.dart';
import 'package:testing_bloc_course/api/notes_api.dart';
import 'package:testing_bloc_course/models.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginEvent>((event, emit) async {
      // start loading
      emit(const AppState(
        isLoading: true,
      ));

      // log in the user
      final loginHandle =
          await loginApi.login(email: event.email, password: event.password);

      emit(AppState(
        isLoading: false,
        loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
        loginHandle: loginHandle,
        fetchedNotes: null,
      ));
    });

    on<LoadNotesEvent>((event, emit) async {
      // start loading
      emit(
        AppState(
          isLoading: true,
          loginHandle: state.loginHandle,
        ),
      );

      // get the login handle
      final loginHandle = state.loginHandle;
      if (loginHandle != const LoginHandle.fooBar()) {
        // invalid loginHandle, cannot fetch notes
        emit(
          AppState(
            isLoading: false,
            loginHandle: loginHandle,
            loginError: LoginErrors.invalidHandle,
          ),
        );
      } else {
        // we have a valid loginHandle and we want to fetch notes

        final notes = await notesApi.getNotes(loginHandle: loginHandle!);

        emit(
          AppState(
              isLoading: false, loginHandle: loginHandle, fetchedNotes: notes),
        );
      }
    });
  }
}
