import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// ignore: unnecessary_import
import 'package:meta/meta.dart';
import 'dart:math' as math;

part 'app_event.dart';
part 'app_state.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);
typedef AppBlocUrlLoader = Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();
  Future<Uint8List> _loadUrl(String url) =>
      NetworkAssetBundle(Uri.parse(url)).load(url).then(
            (bytesData) => bytesData.buffer.asUint8List(),
          );

  AppBloc({
    required Iterable<String> urls,
    AppBlocRandomUrlPicker? urlPicker,
    Duration? waitBeforeLoading,
    AppBlocUrlLoader? urlLoader,
  }) : super(const AppState.empty()) {
    on<LoadNextUrlEvent>((event, emit) async {
      //start loading
      emit(
        const AppState(isLoading: true),
      );

      final url = (urlPicker ?? _pickRandomUrl)(urls);
      try {
        if (waitBeforeLoading != null) {
          await Future.delayed(waitBeforeLoading);
        }

        final data = await (urlLoader ?? _loadUrl)(url);

        emit(AppState(isLoading: false, data: data));
      } catch (e) {
        emit(AppState(isLoading: false, error: e));
      }
    });
  }
}
