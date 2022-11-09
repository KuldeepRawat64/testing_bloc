import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'api/login_api.dart';
import 'api/notes_api.dart';
import 'bloc/app_bloc.dart';
import 'dialogs/generic_dialog.dart';
import 'dialogs/loading_screen.dart';
import 'models.dart';
import 'strings.dart';
import 'views/iterable_list_view.dart';
import 'views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
        acceptedLoginHandle: const LoginHandle.fooBar(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homepage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          builder: (context, state) {
            final notes = state.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context
                      .read<AppBloc>()
                      .add(LoginEvent(email: email, password: password));
                },
              );
            } else {
              return notes.toListView();
            }
          },
          listener: (context, state) {
            //loading screen
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            // handling error
            final loginError = state.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionsBuilder: () => {ok: true},
              );
            }

            // If we are logged in but we have not fetchedNotes, fetch them now
            if (state.isLoading == false &&
                state.loginError == null &&
                state.loginHandle == const LoginHandle.fooBar() &&
                state.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNotesEvent());
            }
          },
        ),
      ),
    );
  }
}
