import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:testing_bloc_course/model/person.dart';

part 'person_event.dart';
part 'person_state.dart';

extension IsEqualToIgnoringOrder<T> on Iterable<T> {
  bool isEqualToIgnoringOrder(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

class PersonBloc extends Bloc<PersonEvent, PersonFetched?> {
  final Map<String, Iterable<Person>> _cache = {};
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
        final loader = event.loader;
        final persons = await loader(url);
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
