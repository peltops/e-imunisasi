import 'package:eimunisasi/routers/route_paths/contact_route_paths.dart';
import 'package:go_router/go_router.dart';

import '../features/contact/presentation/clinic/clinic_list_screen.dart';
import '../features/contact/presentation/health_worker/health_worker_list_screen.dart';

class ContactRouter {
  static List<RouteBase> routes = [
    GoRoute(
      path: ContactRoutePaths.healthWorkers.path,
      builder: (_, state) => HealthWorkerListScreen(
        name: (state.extra as Map<String, dynamic>)['name'],
      ),
    ),
    GoRoute(
      path: ContactRoutePaths.clinics.path,
      builder: (_, state) => ClinicListScreen(
        name: (state.extra as Map<String, dynamic>)['name'],
      ),
    ),
  ];
}
