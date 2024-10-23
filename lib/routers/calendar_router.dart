import 'package:eimunisasi/features/calendar/logic/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:eimunisasi/features/calendar/presentation/screens/update_event_calendar_screen.dart';
import 'package:eimunisasi/routers/route_paths/calendar_route_paths.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/data/models/calendar_model.dart';
import '../features/calendar/presentation/screens/add_event_calendar_screen.dart';

class CalendarRouter {
  static List<RouteBase> routes = [
    GoRoute(
      path: CalendarRoutePaths.addCalendar.path,
      builder: (_, state) => BlocProvider.value(
        value: (state.extra as Map<String, dynamic>)['bloc'] as CalendarBloc,
        child: AddEventCalendarScreen(),
      ),
    ),
    GoRoute(
      path: CalendarRoutePaths.editCalendar.path,
      builder: (_, state) => BlocProvider.value(
        value: (state.extra as Map<String, dynamic>)['bloc'] as CalendarBloc,
        child: UpdateEventCalendarScreen(
          event: (state.extra as Map<String, dynamic>)['data'] as CalendarModel,
        ),
      ),
    ),
  ];
}
