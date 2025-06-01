import 'package:bloc/bloc.dart';
import 'package:eimunisasi/core/utils/bloc_observer.dart';
import 'package:eimunisasi/services/notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'features/calendar/data/models/hive_calendar_activity_model.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

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
