import 'package:country_code_picker/country_code_picker.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/routers/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthenticationBloc>(),
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.pink[300],
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: Colors.pink[500], secondary: Colors.pink[300]),
        fontFamily: 'Nunito',
      ),
      supportedLocales: [
        Locale("en"),
        Locale("id"),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
