part of 'person_bloc.dart';

const person1 = 'http://127.0.0.1:5500/api/persons1.json';
const person2 = 'http://127.0.0.1:5500/api/persons2.json';

// enum PersonUrl {
//   persons1,
//   persons2,
// }

// extension UrlString on PersonUrl {
//   String get urlString {
//     switch (this) {
//       case PersonUrl.persons1:
//         return 'http://127.0.0.1:5500/api/persons1.json';
//       case PersonUrl.persons2:
//         return 'http://127.0.0.1:5500/api/persons2.json';
//     }
//   }
// }

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class PersonEvent {
  const PersonEvent();
}

@immutable
class LoadPersonEvent extends PersonEvent {
  final String url;
  final PersonLoader loader;

  const LoadPersonEvent({
    required this.url,
    required this.loader,
  }) : super();
}
