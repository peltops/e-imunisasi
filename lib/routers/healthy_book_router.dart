import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/routers/route_paths/healthy_book_route_paths.dart';
import 'package:go_router/go_router.dart';

import '../features/healthy_book/presentation/screens/patient_medical_history_screen.dart';
import '../features/profile/presentation/screens/list_children_screen.dart';

class HealthyBookRouter {
  static List<RouteBase> routes = [
    GoRoute(
      path: HealthyBookRoutePaths.chooseChildMedicalRecord.path,
      builder: (context, __) => ListChildrenScreen(
        onSelected: (child) {
          context.push(
            HealthyBookRoutePaths.patientMedicalRecordScreen.fullPath,
            extra: child,
          );
        },
      ),
    ),
    GoRoute(
      path: HealthyBookRoutePaths.patientMedicalRecordScreen.path,
      builder: (context, state) => PatientMedicalHistoryScreen(
        child: state.extra as Anak,
      ),
    ),
  ];
}
