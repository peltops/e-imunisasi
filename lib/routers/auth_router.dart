import 'package:eimunisasi/features/authentication/presentation/screens/auth/login_email_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/login_phone_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/otp_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/register_phone_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/register_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/reset_email_password.dart';
import 'package:eimunisasi/routers/route_paths/auth_route_paths.dart';
import 'package:go_router/go_router.dart';

class AuthRouter {
  static List<RouteBase> routes = [
    GoRoute(
      path: AuthRoutePaths.login.path,
      builder: (_, __) => const LoginEmailScreen(),
    ),
    GoRoute(
      path: AuthRoutePaths.loginPhone.path,
      builder: (_, __) => LoginPhoneScreen(),
    ),
    GoRoute(
      path: AuthRoutePaths.register.path,
      builder: (_, __) => const RegisterScreen(),
    ),
    GoRoute(
      path: AuthRoutePaths.registerPhone.path,
      builder: (_, __) => const RegisterPhoneScreen(),
    ),
    GoRoute(
      path: AuthRoutePaths.otp.path,
      builder: (_, state) => OTPScreen(
        state: state.extra as OTPScreenArguments,
      ),
    ),
    GoRoute(
      path: AuthRoutePaths.resetEmailPassword.path,
      builder: (_, __) => const ResetEmailPasswordScreen(),
    ),
  ];
}
