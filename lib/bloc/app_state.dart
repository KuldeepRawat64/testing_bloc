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

  @override
  bool operator ==(covariant AppState other) =>
      isLoading == other.isLoading &&
      (data ?? []).isEqualTo(other.data ?? []) &&
      error == other.error;

  @override
  int get hashCode => Object.hash(
        isLoading,
        data,
        error,
      );
}

extension Comparison<E> on List<E> {
  bool isEqualTo(List<E> other) {
    if (identical(this, other)) {
      return true;
    }
    if (length != other.length) {
      return false;
    }
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
