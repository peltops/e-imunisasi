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
