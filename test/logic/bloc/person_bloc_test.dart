import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_bloc_course/logic/bloc/person_bloc.dart';
import 'package:testing_bloc_course/model/person.dart';

const mockedPerson1 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

const mockedPerson2 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30),
];

Future<Iterable<Person>> mockFunction1(String _) => Future.value(mockedPerson1);

Future<Iterable<Person>> mockFunction2(String _) => Future.value(mockedPerson2);

void main() {
  // write tests

  late PersonBloc bloc;

  setUp(() => bloc = PersonBloc());

  blocTest<PersonBloc, PersonFetched?>(
    'Test initial state',
    build: () => bloc,
    verify: (bloc) => expect(bloc.state, null),
  );

  // fetch mockdata (person1) and compare it with the fetchResult where isRetrieveFromCache is false

  blocTest<PersonBloc, PersonFetched?>(
    'Mock retrieve data from the first iterable',
    build: () => bloc,
    act: (bloc) {
      bloc.add(const LoadPersonEvent(
        url: 'dummy_url_1',
        loader: mockFunction1,
      ));
      bloc.add(const LoadPersonEvent(
        url: 'dummy_url_1',
        loader: mockFunction1,
      ));
    },
    expect: () => [
      const PersonFetched(
        persons: mockedPerson1,
        isRetrievedFromCache: false,
      ),
      const PersonFetched(
        persons: mockedPerson1,
        isRetrievedFromCache: true,
      )
    ],
  );

  // fetch mockdata (person2) and compare it with the fetchResult

  blocTest<PersonBloc, PersonFetched?>(
    'Mock retrieve data from the second iterable',
    build: () => bloc,
    act: (bloc) {
      bloc.add(const LoadPersonEvent(
        url: 'dummy_url_2',
        loader: mockFunction2,
      ));
      bloc.add(const LoadPersonEvent(
        url: 'dummy_url_2',
        loader: mockFunction2,
      ));
    },
    expect: () => [
      const PersonFetched(
        persons: mockedPerson2,
        isRetrievedFromCache: false,
      ),
      const PersonFetched(
        persons: mockedPerson2,
        isRetrievedFromCache: true,
      )
    ],
  );
}
