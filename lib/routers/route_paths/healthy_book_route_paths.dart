import 'package:eimunisasi/routers/models/route_model.dart';
import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';

class HealthyBookRoutePaths {
  static const RouteModel chooseChildMedicalRecord = RouteModel(
    path: 'choose-child-medical-record',
    parent: RootRoutePaths.healthyBook,
  );
  static const RouteModel patientMedicalRecordScreen = RouteModel(
    path: 'patient-medical-record-screen',
    parent: RootRoutePaths.healthyBook,
  );
}
