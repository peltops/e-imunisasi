import 'package:eimunisasi/routers/models/route_model.dart';
import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';

class ContactRoutePaths {
  static const RouteModel healthWorkers = RouteModel(
    path: 'health-workers',
    parent: RootRoutePaths.contact,
  );
  static const RouteModel clinics = RouteModel(
    path: 'clinics',
    parent: RootRoutePaths.contact,
  );
}
