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
import 'package:eimunisasi/features/healthy_book/presentation/screens/healthy_book_screen.dart';
import 'package:eimunisasi/features/healthy_book/presentation/screens/patient_medical_history_screen.dart';
import 'package:eimunisasi/features/onboarding/onboarding.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/features/profile/presentation/screens/list_children_screen.dart';
import 'package:eimunisasi/features/profile/presentation/screens/parent_profile_screen.dart';
import 'package:eimunisasi/models/appointment.dart';
import 'package:eimunisasi/models/informasi_aplikasi.dart';
import 'package:eimunisasi/pages/home/bantuan/child/detail_informasi.dart';
import 'package:eimunisasi/pages/home/bantuan/child/menu_eimunisasi_manual.dart';
import 'package:eimunisasi/pages/home/bantuan/child/menu_infomasi_kesehatan.dart';
import 'package:eimunisasi/pages/home/bantuan/child/menu_rumah_sakit.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/child/list_anak.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/rekam_medis_pasien_screen.dart';
import 'package:eimunisasi/pages/home/utama/kontak/klinik/list_daftar_klinik.dart';
import 'package:eimunisasi/pages/home/utama/kontak/tenaga_kesehatan/list_daftar_nakes.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/daftar_vaksinasi.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/konfirmasi_janji.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/list_anak_vaksinasi.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/list_janji.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/list_nakes_vaksinasi.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/vaksinasi.dart';
import 'package:eimunisasi/routers/auth_local_router.dart';
import 'package:eimunisasi/routers/auth_router.dart';
import 'package:eimunisasi/routers/profile_router.dart';
import 'package:eimunisasi/routers/route_paths/auth_route_paths.dart';
import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';
import 'package:eimunisasi/routers/route_paths/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'calendar_router.dart';

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
      path: RoutePaths.chooseChildMedicalRecord,
      builder: (context, __) => ListChildrenScreen(
        onSelected: (child) {
          context.go(
            RoutePaths.patientMedicalRecord,
            extra: child,
          );
        },
      ),
    ),
    GoRoute(
      path: RoutePaths.patientMedicalRecordScreen,
      builder: (context, state) => PatientMedicalHistoryScreen(
        child: state.extra as Anak,
      ),
    ),
    GoRoute(
      path: RoutePaths.vaccination,
      builder: (_, __) => VaksinasiPage(),
    ),
    GoRoute(
      path: RoutePaths.listAnak,
      builder: (_, state) => ListAnak(
        page: (state.extra as Map<String, dynamic>)['page'],
      ),
    ),
    GoRoute(
      path: RoutePaths.patientMedicalRecord,
      builder: (_, state) => RekamMedisPasienScreen(
        anak: state.extra as Anak,
      ),
    ),
    GoRoute(
      path: RoutePaths.healthWorkers,
      builder: (_, state) => ListDaftarNakes(
        nama: (state.extra as Map<String, dynamic>)['name'],
      ),
    ),
    GoRoute(
      path: RoutePaths.clinics,
      builder: (_, state) => ListDaftarKlinik(),
    ),
    GoRoute(
      path: RoutePaths.vaccinationConfirmation,
      builder: (_, state) => KonfirmasiVaksinasiPage(
        appointment: state.extra as AppointmentModel,
      ),
    ),
    GoRoute(
      path: RoutePaths.chooseHealthWorkers,
      builder: (_, state) => ChooseNakesScreen(
        anak: state.extra as Anak,
      ),
    ),
    GoRoute(
      path: RoutePaths.makeAppointmentVaccination,
      builder: (_, state) => DaftarVaksinasiPage(
        nakes: (state.extra as Map<String, dynamic>)['healthWorker'],
        anak: (state.extra as Map<String, dynamic>)['child'],
      ),
    ),
    GoRoute(
      path: RoutePaths.chooseChildVaccination,
      builder: (_, state) => ListAnakVaksinasi(),
    ),
    GoRoute(
      path: RoutePaths.appointmentVaccination,
      builder: (_, state) => ListJanjiVaksinasi(),
    ),
    GoRoute(
      path: RoutePaths.healthyBook,
      builder: (_, state) => HealthyBookScreen(),
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
