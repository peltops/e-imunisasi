import 'package:country_code_picker/country_localizations.dart';
import 'package:eimunisasi/models/hive_calendar_activity.dart';
import 'package:eimunisasi/pages/splash/splash.dart';
import 'package:eimunisasi/services/auth.dart';
import 'package:eimunisasi/services/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(CalendarsHiveAdapter());
  await Hive.openBox<CalendarsHive>('calendar_activity');
  NotificationService().initialize();
  tz.initializeTimeZones();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users>.value(
      value: AuthService().userActive,
      builder: (context, snapshot) {
        return MultiProvider(
            child: MaterialApp(
              supportedLocales: [
                Locale("af"),
                Locale("am"),
                Locale("ar"),
                Locale("az"),
                Locale("be"),
                Locale("bg"),
                Locale("bn"),
                Locale("bs"),
                Locale("ca"),
                Locale("cs"),
                Locale("da"),
                Locale("de"),
                Locale("el"),
                Locale("en"),
                Locale("es"),
                Locale("et"),
                Locale("fa"),
                Locale("fi"),
                Locale("fr"),
                Locale("gl"),
                Locale("ha"),
                Locale("he"),
                Locale("hi"),
                Locale("hr"),
                Locale("hu"),
                Locale("hy"),
                Locale("id"),
                Locale("is"),
                Locale("it"),
                Locale("ja"),
                Locale("ka"),
                Locale("kk"),
                Locale("km"),
                Locale("ko"),
                Locale("ku"),
                Locale("ky"),
                Locale("lt"),
                Locale("lv"),
                Locale("mk"),
                Locale("ml"),
                Locale("mn"),
                Locale("ms"),
                Locale("nb"),
                Locale("nl"),
                Locale("nn"),
                Locale("no"),
                Locale("pl"),
                Locale("ps"),
                Locale("pt"),
                Locale("ro"),
                Locale("ru"),
                Locale("sd"),
                Locale("sk"),
                Locale("sl"),
                Locale("so"),
                Locale("sq"),
                Locale("sr"),
                Locale("sv"),
                Locale("ta"),
                Locale("tg"),
                Locale("th"),
                Locale("tk"),
                Locale("tr"),
                Locale("tt"),
                Locale("uk"),
                Locale("ug"),
                Locale("ur"),
                Locale("uz"),
                Locale("vi"),
                Locale("zh")
              ],
              localizationsDelegates: [
                CountryLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              theme: ThemeData(
                primaryColor: Colors.pink[300],
                primarySwatch: Colors.pink,
                accentColor: Colors.pink[400],
                fontFamily: 'Nunito',
              ),
              home: Splash(),
            ),
            providers: [
              ChangeNotifierProvider(create: (_) => NotificationService())
            ]);
      },
      initialData: null,
    );
  }
}
