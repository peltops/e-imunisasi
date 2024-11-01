import 'package:eimunisasi/routers/models/route_model.dart';
import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';

class VaccinationRoutePaths {
  static const RouteModel chooseChildVaccination = RouteModel(
    path: 'choose-child',
    parent: RootRoutePaths.vaccination,
  );
  static const RouteModel chooseNakesVaccination = RouteModel(
    path: 'choose-nakes',
    parent: RootRoutePaths.vaccination,
  );
  static const RouteModel makeAppointmentVaccination = RouteModel(
    path: 'make-appointment',
    parent: RootRoutePaths.vaccination,
  );
  static const RouteModel vaccinationConfirmation = RouteModel(
    path: 'confirmation',
    parent: RootRoutePaths.vaccination,
  );
  static const RouteModel appointmentVaccination = RouteModel(
    path: 'appointment',
    parent: RootRoutePaths.vaccination,
  );
}
