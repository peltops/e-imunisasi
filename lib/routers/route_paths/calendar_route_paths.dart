import 'package:eimunisasi/routers/models/route_model.dart';
import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';

class CalendarRoutePaths {
  static const RouteModel addCalendar = RouteModel(
    path: 'add',
    parent: RootRoutePaths.calendar,
  );

  static const RouteModel editCalendar = RouteModel(
    path: 'edit',
    parent: RootRoutePaths.calendar,
  );
}
