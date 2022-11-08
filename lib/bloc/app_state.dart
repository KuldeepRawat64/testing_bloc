// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_bloc.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchedNotes = null;

  const AppState({
    required this.isLoading,
    this.loginError,
    this.loginHandle,
    this.fetchedNotes,
  });

  @override
  String toString() {
    return 'AppState(isLoading: $isLoading, loginError: $loginError, loginHandle: $loginHandle, fetchedNotes: $fetchedNotes)';
  }
}
