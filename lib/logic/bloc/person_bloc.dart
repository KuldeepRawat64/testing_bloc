import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:testing_bloc_course/main.dart';
import 'package:testing_bloc_course/model/person.dart';
import 'package:testing_bloc_course/resources/repository.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonFetched?> {
  final _repository = Repository();
  final Map<PersonUrl, Iterable<Person>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonEvent>((event, emit) async {
      final url = event.url;

      if (_cache.containsKey(url)) {
        // we have the value in the cache
        final cachedPersons = _cache[url]!;
        final result = PersonFetched(
          persons: cachedPersons,
          isRetrievedFromCache: true,
        );

        emit(result);
      } else {
        final persons = await _repository.getPersons(url.urlString);
        _cache[url] = persons;
        final result = PersonFetched(
          persons: persons,
          isRetrievedFromCache: false,
        );

        emit(result);
      }
    });
  }
}
