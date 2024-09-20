import 'package:eimunisasi/routers/models/route_model.dart';
import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';

class AuthRoutePaths {
  static const RouteModel login = RouteModel(
    path: 'login',
    parent: RootRoutePaths.auth,
  );

  static const RouteModel loginPhone = RouteModel(
    path: 'login-phone',
    parent: RootRoutePaths.auth,
  );

  static const RouteModel register = RouteModel(
    path: 'register',
    parent: RootRoutePaths.auth,
  );

  static const RouteModel registerPhone = RouteModel(
    path: 'register-phone',
    parent: RootRoutePaths.auth,
  );

  static const RouteModel otp = RouteModel(
    path: 'otp',
    parent: RootRoutePaths.auth,
  );

  static const RouteModel resetEmailPassword = RouteModel(
    path: 'reset-email-password',
    parent: RootRoutePaths.auth,
  );

  static const RouteModel passcode = RouteModel(
    path: 'passcode',
    parent: RootRoutePaths.authLocal,
  );

  static const RouteModel confirmPasscode = RouteModel(
    path: 'confirm-passcode',
    parent: RootRoutePaths.authLocal,
  );

  static const RouteModel loginWithSeribaseOauth = RouteModel(
    path: 'login-with-seribase-oauth',
    parent: RootRoutePaths.auth,
  );
}
