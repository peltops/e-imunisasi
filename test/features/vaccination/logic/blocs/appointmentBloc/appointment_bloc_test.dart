import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_payment_entity.dart';
import 'package:eimunisasi/features/vaccination/logic/blocs/appointmentBloc/appointment_bloc.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:eimunisasi/features/vaccination/data/repositories/appointment_repository.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAppointmentRepository extends Mock implements AppointmentRepository {}

void main() {
  late AppointmentRepository appointmentRepository;
  late AppointmentBloc appointmentBloc;

  setUp(() {
    appointmentRepository = MockAppointmentRepository();
    appointmentBloc = AppointmentBloc(appointmentRepository);
  });

  setUpAll(() {
    registerFallbackValue(AppointmentModel());
  });

  group('AppointmentBloc', () {
    blocTest<AppointmentBloc, AppointmentState>(
      'emits [inProgress, success] when LoadAppointmentsEvent is added and getAppointments succeeds',
      build: () {
        when(() => appointmentRepository.getAppointments(
              userId: any(named: 'userId'),
              sortCriteria: any(named: 'sortCriteria'),
            )).thenAnswer((_) async => <AppointmentModel>[]);
        return appointmentBloc;
      },
      act: (bloc) => bloc.add(LoadAppointmentsEvent('user1')),
      expect: () => [
        AppointmentState(
            statusGetAppointments: FormzSubmissionStatus.inProgress),
        AppointmentState(
            statusGetAppointments: FormzSubmissionStatus.success,
            getAppointments: <AppointmentModel>[]),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'emits [inProgress, failure] when LoadAppointmentsEvent is added and getAppointments fails',
      build: () {
        when(() => appointmentRepository.getAppointments(
            userId: any(named: 'userId'))).thenThrow(Exception('error'));
        return appointmentBloc;
      },
      act: (bloc) => bloc.add(LoadAppointmentsEvent('user1')),
      expect: () => [
        AppointmentState(
            statusGetAppointments: FormzSubmissionStatus.inProgress),
        AppointmentState(
            statusGetAppointments: FormzSubmissionStatus.failure,
            errorMessage: 'Gagal memuat data janji'),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'emits [inProgress, success] when CreateAppointmentEvent is added and setAppointment succeeds',
      build: () {
        when(() => appointmentRepository.setAppointment(any())).thenAnswer(
          (_) async => AppointmentOrderEntity(),
        );
        return appointmentBloc;
      },
      act: (bloc) => bloc.add(CreateAppointmentEvent(AppointmentModel())),
      expect: () => [
        AppointmentState(statusSubmit: FormzSubmissionStatus.inProgress),
        AppointmentState(
          statusSubmit: FormzSubmissionStatus.success,
          appointmentWithOrder: AppointmentOrderEntity(),
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'emits [inProgress, failure] when CreateAppointmentEvent is added and setAppointment fails',
      build: () {
        when(() => appointmentRepository.setAppointment(any()))
            .thenThrow(Exception('error'));
        return appointmentBloc;
      },
      act: (bloc) => bloc.add(CreateAppointmentEvent(AppointmentModel())),
      expect: () => [
        AppointmentState(statusSubmit: FormzSubmissionStatus.inProgress),
        AppointmentState(
            statusSubmit: FormzSubmissionStatus.failure,
            errorMessage: 'Gagal membuat janji'),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'emits [inProgress, success] when UpdateAppointmentEvent is added and updateAppointment succeeds',
      build: () {
        when(() => appointmentRepository.updateAppointment(any()))
            .thenAnswer((_) async => AppointmentModel());
        return appointmentBloc;
      },
      act: (bloc) => bloc.add(UpdateAppointmentEvent(AppointmentModel())),
      expect: () => [
        AppointmentState(statusSubmit: FormzSubmissionStatus.inProgress),
        AppointmentState(
          statusSubmit: FormzSubmissionStatus.success,
          appointmentWithOrder: AppointmentOrderEntity(
            appointment: AppointmentModel(),
          ),
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'emits [inProgress, failure] when UpdateAppointmentEvent is added and updateAppointment fails',
      build: () {
        when(() => appointmentRepository.updateAppointment(any()))
            .thenThrow(Exception('error'));
        return appointmentBloc;
      },
      act: (bloc) => bloc.add(UpdateAppointmentEvent(AppointmentModel())),
      expect: () => [
        AppointmentState(statusSubmit: FormzSubmissionStatus.inProgress),
        AppointmentState(
            statusSubmit: FormzSubmissionStatus.failure,
            errorMessage: 'Gagal mengubah janji'),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'emits [inProgress, success] when LoadAppointmentEvent is added and getAppointment succeeds',
      build: () {
        when(() => appointmentRepository.getAppointment(id: any(named: 'id')))
            .thenAnswer((_) async => AppointmentOrderEntity());
        return appointmentBloc;
      },
      act: (bloc) => bloc.add(LoadAppointmentEvent('1')),
      expect: () => [
        AppointmentState(
            statusGetAppointment: FormzSubmissionStatus.inProgress),
        AppointmentState(
            statusGetAppointment: FormzSubmissionStatus.success,
            getAppointmentWithOrder: AppointmentOrderEntity()),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'emits [inProgress, failure] when LoadAppointmentEvent is added and getAppointment fails',
      build: () {
        when(() => appointmentRepository.getAppointment(id: any(named: 'id')))
            .thenThrow(Exception('error'));
        return appointmentBloc;
      },
      act: (bloc) => bloc.add(LoadAppointmentEvent('1')),
      expect: () => [
        AppointmentState(
            statusGetAppointment: FormzSubmissionStatus.inProgress),
        AppointmentState(
            statusGetAppointment: FormzSubmissionStatus.failure,
            errorMessage: 'Gagal memuat data janji'),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'emits sortCriteria when ChangeSortCriteriaEvent is added',
      build: () {
        return appointmentBloc;
      },
      act: (bloc) => bloc.add(ChangeSortCriteriaEvent('name')),
      expect: () => [
        AppointmentState(
          sortCriteria: 'name',
        ),
      ],
    );
  });

  group('AppointmentEvent', () {
    group('LoadAppointmentsEvent', () {
      test('props', () {
        expect(
          LoadAppointmentsEvent('user1').props,
          ['user1'],
        );
      });
    });

    group('CreateAppointmentEvent', () {
      test('props', () {
        expect(
          CreateAppointmentEvent(AppointmentModel()).props,
          [AppointmentModel()],
        );
      });
    });

    group('UpdateAppointmentEvent', () {
      test('props', () {
        expect(
          UpdateAppointmentEvent(AppointmentModel()).props,
          [AppointmentModel()],
        );
      });
    });

    group('LoadAppointmentEvent', () {
      test('props', () {
        expect(
          LoadAppointmentEvent('1').props,
          ['1'],
        );
      });
    });

    group('ChangeSortCriteriaEvent', () {
      test('props', () {
        expect(
          ChangeSortCriteriaEvent('name').props,
          ['name'],
        );
      });
    });
  });
}
