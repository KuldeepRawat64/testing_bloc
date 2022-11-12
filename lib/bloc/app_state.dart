// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_bloc.dart';

@immutable
class AppState {
  final bool isLoading;
  final Uint8List? data;
  final Object? error;
  const AppState({
    required this.isLoading,
    this.data,
    this.error,
  });

  const AppState.empty()
      : isLoading = false,
        data = null,
        error = null;
}
