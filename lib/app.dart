import 'package:country_code_picker/country_code_picker.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/pages/onboarding/onboarding.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/loading.dart';
import 'features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'features/authentication/presentation/screens/auth/login_phone_screen.dart';
import 'features/authentication/presentation/screens/local_auth/passcode_screen.dart';
import 'features/authentication/presentation/screens/splash/splash_screen.dart';

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
    return MaterialApp(
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
        home: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationError) {
              snackbarCustom(state.message).show(context);
            }
          },
          builder: (context, state) {
            if (state is Uninitialized) {
              return const SplashScreen();
            } else if (state is Loading) {
              return const LoadingScreen();
            } else if (state is Authenticated) {
              return const PasscodeScreen();
            } else if (state is Unauthenticated) {
              if (state.isSeenOnboarding) {
                return const LoginPhoneScreen();
              }
              return OnboardScreen();
            } else if (state is AuthenticationError) {
              return const LoginPhoneScreen();
            }
            return Container();
          },
        ));
  }
}
