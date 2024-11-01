import 'package:eimunisasi/routers/models/route_model.dart';

class RootRoutePaths {
  static const RouteModel root = RouteModel(
    path: '/',
  );
  static const RouteModel notFound = RouteModel(
    path: '/not-found',
  );
  static const RouteModel splash = RouteModel(
    path: '/splash',
  );
  static const RouteModel onboarding = RouteModel(
    path: '/onboarding',
  );
  static const RouteModel auth = RouteModel(
    path: '/auth',
  );
  static const RouteModel authLocal = RouteModel(
    path: '/auth-local',
  );
  static const RouteModel dashboard = RouteModel(
    path: '/dashboard',
  );
  static const RouteModel profile = RouteModel(
    path: '/profile',
  );
  static const RouteModel calendar = RouteModel(
    path: '/calendar',
  );
  static const RouteModel healthyBook = RouteModel(
    path: '/healthy-book',
  );
}
