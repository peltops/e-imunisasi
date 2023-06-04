import 'package:bloc/bloc.dart';
import 'package:eimunisasi/models/hive_calendar_activity.dart';
import 'package:eimunisasi/services/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'injection.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(CalendarsHiveAdapter());
  await Hive.openBox<CalendarsHive>('calendar_activity');
  NotificationService().initialize();
  tz.initializeTimeZones();
  await configureDependencies();
  Bloc.observer = AppBlocObserver();
  runApp(App());
}

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('onClose -- ${bloc.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint(transition.toString());
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<Users?>.value(
//       value: AuthService().userActive,
//       builder: (context, snapshot) {
//         return MultiProvider(
//             child: MaterialApp(
//               supportedLocales: [
//                 Locale("en"),
//                 Locale("id"),
//               ],
//               localizationsDelegates: [
//                 CountryLocalizations.delegate,
//                 GlobalMaterialLocalizations.delegate,
//                 GlobalWidgetsLocalizations.delegate,
//               ],
//               theme: ThemeData(
//                 primaryColor: Colors.pink[300],
//                 primarySwatch: Colors.pink,
//                 colorScheme: ColorScheme.fromSwatch().copyWith(
//                     primary: Colors.pink[500], secondary: Colors.pink[300]),
//                 fontFamily: 'Nunito',
//               ),
//               home: Splash(),
//             ),
//             providers: [
//               ChangeNotifierProvider(create: (_) => NotificationService())
//             ]);
//       },
//       initialData: null,
//     );
//   }
// }
