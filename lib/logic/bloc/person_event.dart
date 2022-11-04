part of 'person_bloc.dart';

@immutable
abstract class PersonEvent {
  const PersonEvent();
}

@immutable
class LoadPersonEvent extends PersonEvent {
  final PersonUrl url;

  const LoadPersonEvent({required this.url}) : super();
}
