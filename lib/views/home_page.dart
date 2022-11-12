import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_course/bloc/top_bloc.dart';
import 'package:testing_bloc_course/bloc/bottom_bloc.dart';
import 'package:testing_bloc_course/model/constants.dart';
import 'package:testing_bloc_course/views/app_bloc_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<TopBloc>(
                create: (_) => TopBloc(
                    urls: images,
                    waitBeforeLoading: const Duration(seconds: 3)),
              ),
              BlocProvider<BottomBloc>(
                create: (_) => BottomBloc(
                    urls: images,
                    waitBeforeLoading: const Duration(seconds: 3)),
              ),
            ],
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: const [
                AppBlocView<TopBloc>(),
                AppBlocView<BottomBloc>()
              ],
            ),
          )),
    );
  }
}
