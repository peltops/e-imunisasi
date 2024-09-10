import 'package:eimunisasi/features/authentication/logic/cubit/local_auth_cubit/local_auth_cubit.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/local_auth/confirm_passcode_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/local_auth/passcode_screen.dart';
import 'package:eimunisasi/routers/route_paths/auth_route_paths.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthLocalRouter {
  static List<RouteBase> routes = [
    GoRoute(
      path: AuthRoutePaths.passcode.path,
      builder: (_, __) => const PasscodeScreen(),
    ),
    GoRoute(
      path: AuthRoutePaths.confirmPasscode.path,
      builder: (_, state) {
        return BlocProvider.value(
          value: state.extra as LocalAuthCubit,
          child: const ConfirmPasscodeScreen(),
        );
      },
    ),
  ];
}
