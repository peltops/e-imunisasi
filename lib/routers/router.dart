import 'package:eimunisasi/core/loading.dart';
import 'package:eimunisasi/core/widgets/error.dart';
import 'package:eimunisasi/core/widgets/snackbar_custom.dart';
import 'package:eimunisasi/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/login_seribase_oauth_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/local_auth/passcode_screen.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/splash/splash_screen.dart';
import 'package:eimunisasi/features/bottom_navbar/presentation/screens/bottom_navbar.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/features/calendar/presentation/screens/add_event_calendar_screen.dart';
import 'package:eimunisasi/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:eimunisasi/features/calendar/presentation/screens/update_event_calendar_screen.dart';
import 'package:eimunisasi/features/contact/presentation/contact_screen.dart';
import 'package:eimunisasi/features/healthy_book/presentation/screens/healthy_book_screen.dart';
import 'package:eimunisasi/features/onboarding/onboarding.dart';
import 'package:eimunisasi/features/profile/presentation/screens/parent_profile_screen.dart';
import 'package:eimunisasi/features/vaccination/presentation/screens/vaccination_screen.dart';
import 'package:eimunisasi/models/informasi_aplikasi.dart';
import 'package:eimunisasi/pages/home/bantuan/child/detail_informasi.dart';
import 'package:eimunisasi/pages/home/bantuan/child/menu_eimunisasi_manual.dart';
import 'package:eimunisasi/pages/home/bantuan/child/menu_infomasi_kesehatan.dart';
import 'package:eimunisasi/pages/home/bantuan/child/menu_rumah_sakit.dart';
import 'package:eimunisasi/routers/auth_local_router.dart';
import 'package:eimunisasi/routers/auth_router.dart';
import 'package:eimunisasi/routers/contact_router.dart';
import 'package:eimunisasi/routers/profile_router.dart';
import 'package:eimunisasi/routers/route_paths/auth_route_paths.dart';
import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';
import 'package:eimunisasi/routers/route_paths/route_paths.dart';
import 'package:eimunisasi/routers/vaccination_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'calendar_router.dart';
import 'healthy_book_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: RootRoutePaths.root.path,
      builder: (context, state) {
        final error = state.uri.queryParameters['error'];
        final errorCode = state.uri.queryParameters['error_code'];
        final errorDescription = state.uri.queryParameters['error_description'];

        if (error != null && errorCode != null && errorDescription != null) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              snackbarCustom(errorDescription).show(context);
            },
          );
        }

        return BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationError) {
              snackbarCustom(state.message).show(context);
            }
          },
          builder: (context, state) {
            if (state is Uninitialized) {
              return const SplashScreen();
            } else if (state is Loading) {
              return const LoadingScreen();
            } else if (state is Authenticated) {
              return const PasscodeScreen();
            } else if (state is Unauthenticated) {
              if (state.isSeenOnboarding) {
                return const LoginSeribaseOauthScreen();
              }
              return OnboardScreen();
            } else if (state is AuthenticationError) {
              return const LoginSeribaseOauthScreen();
            }
            return Container();
          },
        );
      },
    ),
    GoRoute(
      path: RootRoutePaths.auth.path,
      routes: AuthRouter.routes,
      redirect: (_, state) {
        if (state.fullPath == RootRoutePaths.auth.fullPath) {
          return AuthRoutePaths.loginWithSeribaseOauth.fullPath;
        }
        return null;
      },
    ),
    GoRoute(
      path: RootRoutePaths.authLocal.path,
      routes: AuthLocalRouter.routes,
      redirect: (_, state) {
        if (state.fullPath == RootRoutePaths.authLocal.fullPath) {
          return AuthRoutePaths.passcode.fullPath;
        }
        return null;
      },
    ),
    GoRoute(
      path: RootRoutePaths.onboarding.path,
      builder: (_, __) => OnboardScreen(),
    ),
    GoRoute(
      path: RootRoutePaths.splash.path,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: RootRoutePaths.dashboard.path,
      builder: (_, __) => BottomNavbarWrapper(),
    ),
    GoRoute(
      path: RootRoutePaths.profile.path,
      builder: (_, __) => ParentProfileScreen(),
      routes: ProfileRouter.routes,
    ),
    GoRoute(
      path: RoutePaths.addEventCalendar,
      builder: (_, __) => AddEventCalendarScreen(),
    ),
    GoRoute(
      path: RoutePaths.updateEventCalendar,
      builder: (_, state) => UpdateEventCalendarScreen(
        event: state.extra as CalendarModel,
      ),
    ),
    GoRoute(
      path: RoutePaths.hospitals,
      builder: (_, __) => ListDaftarRumahSakit(),
    ),
    GoRoute(
      path: RoutePaths.medicalInformation,
      builder: (_, __) => InformasiKesehatanPage(),
    ),
    GoRoute(
      path: RoutePaths.appManual,
      builder: (_, __) => EimunisasiManualPage(),
    ),
    GoRoute(
      path: RoutePaths.detailInformasi,
      builder: (_, state) => DetailInformasiPage(
        data: state.extra as InformasiAplikasiModel,
      ),
    ),
    GoRoute(
      path: RootRoutePaths.calendar.path,
      builder: (_, __) => const CalendarScreen(),
      routes: CalendarRouter.routes,
    ),
    GoRoute(
      path: RootRoutePaths.vaccination.path,
      builder: (_, __) => VaccinationScreen(),
      routes: VaccinationRouter.routes,
    ),
    GoRoute(
      path: RootRoutePaths.contact.path,
      builder: (_, __) => ContactScreen(),
      routes: ContactRouter.routes,
    ),
    GoRoute(
      path: RootRoutePaths.healthyBook.path,
      builder: (_, state) => HealthyBookScreen(),
      routes: HealthyBookRouter.routes,
    ),
    GoRoute(
      path: RoutePaths.error,
      builder: (context, state) {
        final title = state.uri.queryParameters['error'];
        final desc = state.uri.queryParameters['error_description'];

        return Scaffold(
          body: ErrorContainer(
            title: title,
            message: desc,
          ),
        );
      },
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      body: ErrorContainer(
        title: 'Error',
        message: state.error.toString(),
      ),
    );
  },
);
