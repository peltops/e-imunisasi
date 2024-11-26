import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/contact/logic/clinic_bloc/clinic_bloc.dart';
import 'package:eimunisasi/features/contact/data/repositories/clinic_repository.dart';
import 'package:eimunisasi/core/models/pagination_model.dart';
import 'package:eimunisasi/features/health_worker/data/models/clinic_model.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockClinicRepository extends Mock implements ClinicRepository {}

void main() {
  late ClinicRepository clinicRepository;
  late ClinicBloc clinicBloc;

  setUp(() {
    clinicRepository = MockClinicRepository();
    clinicBloc = ClinicBloc(clinicRepository);
  });

  group('ClinicBloc', () {
    blocTest<ClinicBloc, ClinicState>(
      'emits [inProgress, success] when GetClinics is added and getClinics succeeds',
      build: () {
        when(() =>
            clinicRepository.getClinics(
                page: any(named: 'page'),
                perPage: any(named: 'perPage'),
                search: any(named: 'search'))).thenAnswer(
            (_) async => BasePagination<ClinicModel>(data: <ClinicModel>[]));
        return clinicBloc;
      },
      act: (bloc) => bloc.add(GetClinics()),
      expect: () => [
        ClinicState(statusGetClinic: FormzSubmissionStatus.inProgress),
        ClinicState(
          statusGetClinic: FormzSubmissionStatus.success,
          clinics: BasePagination<ClinicModel>(
            data: <ClinicModel>[],
          ),
        ),
      ],
    );

    blocTest<ClinicBloc, ClinicState>(
      'emits [inProgress, failure] when GetClinics is added and getClinics fails',
      build: () {
        when(() => clinicRepository.getClinics(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
            search: any(named: 'search'))).thenThrow(Exception('error'));
        return clinicBloc;
      },
      act: (bloc) => bloc.add(GetClinics()),
      expect: () => [
        ClinicState(statusGetClinic: FormzSubmissionStatus.inProgress),
        ClinicState(statusGetClinic: FormzSubmissionStatus.failure),
      ],
    );
    blocTest<ClinicBloc, ClinicState>(
      'emits new state with updated page when ChangePage is added',
      build: () {
        when(() => clinicRepository.getClinics(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
            search: any(named: 'search'))).thenAnswer(
          (_) async => BasePagination<ClinicModel>(
            data: <ClinicModel>[],
            metadata: MetadataPaginationModel(
              total: 2,
              page: 1,
              perPage: 10,
            ),
          ),
        );
        return clinicBloc;
      },
      seed: () => ClinicState(
        page: 1,
        clinics: BasePagination<ClinicModel>(
          data: <ClinicModel>[
            ClinicModel(
              id: '1',
              name: 'Clinic 1',
              address: 'Address 1',
            ),
          ],
          metadata: MetadataPaginationModel(
            total: 2,
            page: 1,
            perPage: 10,
          ),
        ),
      ),
      act: (bloc) => bloc.add(ChangePage(2)),
      expect: () => [
        ClinicState(
          page: 2,
          clinics: BasePagination<ClinicModel>(
            data: <ClinicModel>[
              ClinicModel(
                id: '1',
                name: 'Clinic 1',
                address: 'Address 1',
              ),
            ],
            metadata: MetadataPaginationModel(
              total: 2,
              page: 1,
              perPage: 10,
            ),
          ),
        ),
        ClinicState(
          page: 2,
          clinics: BasePagination<ClinicModel>(
            data: <ClinicModel>[
              ClinicModel(
                id: '1',
                name: 'Clinic 1',
                address: 'Address 1',
              ),
            ],
            metadata: MetadataPaginationModel(
              total: 2,
              page: 1,
              perPage: 10,
            ),
          ),
          statusGetClinic: FormzSubmissionStatus.inProgress,
        ),
        ClinicState(
          page: 2,
          clinics: BasePagination<ClinicModel>(
            data: <ClinicModel>[
              ClinicModel(
                id: '1',
                name: 'Clinic 1',
                address: 'Address 1',
              ),
            ],
            metadata: MetadataPaginationModel(
              total: 2,
              page: 1,
              perPage: 10,
            ),
          ),
          statusGetClinic: FormzSubmissionStatus.success,
        ),
      ],
    );

    blocTest<ClinicBloc, ClinicState>(
      'emits new state with updated page when ChangePage is added',
      build: () => clinicBloc,
      act: (bloc) => bloc.add(ChangePage(3)),
      expect: () => [],
    );

    blocTest<ClinicBloc, ClinicState>(
      'emits new state with updated search and resets page when ChangeSearch is added',
      build: () {
        when(() =>
            clinicRepository.getClinics(
                page: any(named: 'page'),
                perPage: any(named: 'perPage'),
                search: any(named: 'search'))).thenAnswer(
            (_) async => BasePagination<ClinicModel>(data: <ClinicModel>[]));
        return clinicBloc;
      },
      act: (bloc) => bloc.add(ChangeSearch('Clinic')),
      expect: () => [
        ClinicState(search: 'Clinic', page: 1),
        ClinicState(
          search: 'Clinic',
          page: 1,
          statusGetClinic: FormzSubmissionStatus.inProgress,
        ),
        ClinicState(
          search: 'Clinic',
          page: 1,
          clinics: BasePagination<ClinicModel>(
            data: <ClinicModel>[],
          ),
          statusGetClinic: FormzSubmissionStatus.success,
        ),
      ],
    );
  });

 group('ChangePage', () {
    test('supports value comparisons', () {
      expect(ChangePage(1), ChangePage(1));
    });
  });

  group('ChangeSearch', () {
    test('supports value comparisons', () {
      expect(ChangeSearch('search'), ChangeSearch('search'));
    });
  });

  group('GetClinics', () {
    test('supports value comparisons', () {
      expect(GetClinics(), GetClinics());
    });
  });
}
