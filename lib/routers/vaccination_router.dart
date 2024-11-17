import 'package:eimunisasi/routers/route_paths/vaccination_route_paths.dart';
import 'package:go_router/go_router.dart';

import '../features/health_worker/presentation/screens/choose_nakes_screen.dart';
import '../features/profile/data/models/anak.dart';
import '../features/profile/presentation/screens/list_children_screen.dart';
import '../features/vaccination/presentation/screens/appointments_screen.dart';
import '../features/vaccination/presentation/screens/vaccination_confirmation_screen.dart';
import '../features/vaccination/presentation/screens/vaccination_register_screen.dart';

class VaccinationRouter {
  static List<RouteBase> routes = [
    GoRoute(
      path: VaccinationRoutePaths.chooseChildVaccination.path,
      builder: (context, __) => ListChildrenScreen(
        onSelected: (child) {
          context.push(
            VaccinationRoutePaths.chooseNakesVaccination.fullPath,
            extra: child,
          );
        },
      ),
    ),
    GoRoute(
      path: VaccinationRoutePaths.chooseNakesVaccination.path,
      builder: (context, state) => ChooseHealthWorkerScreen(
        child: state.extra as Anak,
        onSelected: (nakes) {
          context.push(
            VaccinationRoutePaths.makeAppointmentVaccination.fullPath,
            extra: {
              'healthWorker': nakes,
              'child': state.extra as Anak,
            },
          );
        },
      ),
    ),
    GoRoute(
      path: VaccinationRoutePaths.makeAppointmentVaccination.path,
      builder: (_, state) => VaccinationRegisterScreen(
        nakes: (state.extra as Map<String, dynamic>)['healthWorker'],
        anak: (state.extra as Map<String, dynamic>)['child'],
      ),
    ),
    GoRoute(
      path: VaccinationRoutePaths.vaccinationConfirmation.path,
      builder: (_, state) => VaccinationConfirmationScreen(
        appointmentId: state.extra as String,
      ),
    ),
    GoRoute(
      path: VaccinationRoutePaths.appointmentVaccination.path,
      builder: (_, state) => AppointmentsScreen(),
    ),
  ];
}
