import 'package:eimunisasi/features/authentication/presentation/screens/auth/login_email_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/login_phone_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/register_phone_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/register_screen.dart';
import 'package:eimunisasi/routers/route_paths/auth_route_paths.dart';
import 'package:go_router/go_router.dart';

class AuthRouter {
  static List<RouteBase> routes = [
        GoRoute(
          path: AuthRoutePaths.login.fullPath,
          builder: (_, __) => const LoginEmailScreen(),
        ),
        GoRoute(
          path: AuthRoutePaths.loginPhone.fullPath,
          builder: (_, __) => LoginPhoneScreen(),
        ),
        GoRoute(
          path: AuthRoutePaths.register.fullPath,
          builder: (_, __) => const RegisterScreen(),
        ),
        GoRoute(
          path: AuthRoutePaths.registerPhone.fullPath,
          builder: (_, __) => const RegisterPhoneScreen(),
        ),
  ];
}