// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'person_bloc.dart';

class PersonFetched {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const PersonFetched(
      {required this.persons, required this.isRetrievedFromCache});

  @override
  String toString() =>
      'PersonFetched(persons: $persons, isRetrievedFromCache: $isRetrievedFromCache)';

  @override
  bool operator ==(covariant PersonFetched other) =>
      persons.isEqualToIgnoringOrder(other.persons) &&
      isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetrievedFromCache);
}
