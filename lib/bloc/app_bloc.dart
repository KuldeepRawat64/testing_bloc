import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// ignore: unnecessary_import
import 'package:meta/meta.dart';
import 'dart:math' as math;

part 'app_event.dart';
part 'app_state.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

  AppBloc({
    required Iterable<String> urls,
    AppBlocRandomUrlPicker? urlPicker,
    Duration? waitBeforeLoading,
  }) : super(const AppState.empty()) {
    on<LoadNextUrlEvent>((event, emit) async {
      //start loading
      emit(
        const AppState(isLoading: false),
      );

      final url = (urlPicker ?? _pickRandomUrl(urls));
      final bundle = NetworkAssetBundle(Uri.parse(url.toString()));
      final data = (await bundle.load(url.toString())).buffer.asUint8List();

      emit(AppState(isLoading: false, data: data));
      try {
        if (waitBeforeLoading != null) {
          await Future.delayed(waitBeforeLoading);
        }
      } catch (e) {
        emit(AppState(isLoading: false, error: e));
      }
    });
  }
}
