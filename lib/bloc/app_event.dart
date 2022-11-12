part of 'app_bloc.dart';

@immutable
abstract class AppEvent {
  const AppEvent();
}

class LoadNextUrlEvent implements AppEvent {
  const LoadNextUrlEvent();
}
