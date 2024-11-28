import 'package:bloc/bloc.dart';
import 'package:eimunisasi/core/utils/bloc_observer.dart';
import 'package:eimunisasi/services/notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';
import 'features/calendar/data/models/hive_calendar_activity_model.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://eimunisasi-base-staging.peltops.com',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNzIzNDEzNjAwLAogICJleHAiOiAxODgxMTgwMDAwCn0.LP3Zca0w11eNX1974BpPg0GWShJysP6jw9732kL-Y9c',
  );

  await Hive.initFlutter();
  Hive.registerAdapter(CalendarActivityHiveAdapter());
  NotificationService().initialize();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }
  await configureDependencies();
  runApp(App());
}
