import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/main.dart';

part 'random_name_state.dart';

class RandomNameCubit extends Cubit<RandomNameState> {
  RandomNameCubit() : super(const RandomNameState(name: ''));

  void pickRandomName() =>
      emit(RandomNameState(name: names.getRandomElement()));

  @override
  Future<void> close() {
    RandomNameCubit().close();
    return super.close();
  }
}
