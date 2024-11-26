import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/health_worker/logic/blocs/healthWorkerBloc/health_worker_bloc.dart';
import 'package:eimunisasi/features/health_worker/data/repositories/health_worker_repository.dart';
import 'package:eimunisasi/core/models/pagination_model.dart';
import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHealthWorkerRepository extends Mock
    implements HealthWorkerRepository {}

void main() {
  late HealthWorkerRepository healthWorkerRepository;
  late HealthWorkerBloc healthWorkerBloc;

  setUp(() {
    healthWorkerRepository = MockHealthWorkerRepository();
    healthWorkerBloc = HealthWorkerBloc(healthWorkerRepository);
  });

  group('HealthWorkerBloc', () {
    blocTest<HealthWorkerBloc, HealthWorkerState>(
      'emits [inProgress, success] when GetHealthWorkers is added and getHealthWorkers succeeds',
      build: () {
        when(() => healthWorkerRepository.getHealthWorkers(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
            search: any(named: 'search'))).thenAnswer(
          (_) async => BasePagination<HealthWorkerModel>(
            data: <HealthWorkerModel>[],
          ),
        );
        return healthWorkerBloc;
      },
      act: (bloc) => bloc.add(GetHealthWorkers()),
      expect: () => [
        HealthWorkerState(
          statusGetHealthWorkers: FormzSubmissionStatus.inProgress,
        ),
        HealthWorkerState(
          statusGetHealthWorkers: FormzSubmissionStatus.success,
          healthWorkers: BasePagination<HealthWorkerModel>(
            data: <HealthWorkerModel>[],
          ),
        ),
      ],
    );

    blocTest<HealthWorkerBloc, HealthWorkerState>(
      'emits [inProgress, failure] when GetHealthWorkers is added and getHealthWorkers fails',
      build: () {
        when(() => healthWorkerRepository.getHealthWorkers(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
            search: any(named: 'search'))).thenThrow(Exception('error'));
        return healthWorkerBloc;
      },
      act: (bloc) => bloc.add(GetHealthWorkers()),
      expect: () => [
        HealthWorkerState(
          statusGetHealthWorkers: FormzSubmissionStatus.inProgress,
        ),
        HealthWorkerState(
          statusGetHealthWorkers: FormzSubmissionStatus.failure,
        ),
      ],
    );

    blocTest<HealthWorkerBloc, HealthWorkerState>(
      'emits new state with updated page when ChangePage is added',
      build: () => healthWorkerBloc,
      act: (bloc) => bloc.add(ChangePage(2)),
      expect: () => [],
    );

    blocTest<HealthWorkerBloc, HealthWorkerState>(
      'emits new state with updated search and resets page when ChangeSearch is added',
      build: () {
        when(() => healthWorkerRepository.getHealthWorkers(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
            search: any(named: 'search'))).thenAnswer(
          (_) async => BasePagination<HealthWorkerModel>(
            data: <HealthWorkerModel>[],
          ),
        );
        return healthWorkerBloc;
      },
      act: (bloc) => bloc.add(ChangeSearch('John')),
      expect: () => [
        HealthWorkerState(search: 'John', page: 1),
        HealthWorkerState(
          search: 'John',
          page: 1,
          statusGetHealthWorkers: FormzSubmissionStatus.inProgress,
        ),
        HealthWorkerState(
          search: 'John',
          page: 1,
          statusGetHealthWorkers: FormzSubmissionStatus.success,
          healthWorkers: BasePagination<HealthWorkerModel>(
            data: <HealthWorkerModel>[],
          ),
        ),
      ],
    );
  });

  blocTest<HealthWorkerBloc, HealthWorkerState>(
    'emits new state with updated page when ChangePage is added',
    build: () {
      when(() => healthWorkerRepository.getHealthWorkers(
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
          search: any(named: 'search'))).thenAnswer(
            (_) async => BasePagination<HealthWorkerModel>(
          data: <HealthWorkerModel>[],
          metadata: MetadataPaginationModel(
            total: 2,
            page: 1,
            perPage: 10,
          ),
        ),
      );
      return healthWorkerBloc;
    },
    seed: () => HealthWorkerState(
      page: 1,
      healthWorkers: BasePagination<HealthWorkerModel>(
        data: <HealthWorkerModel>[
          HealthWorkerModel(
            id: '1',
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
      HealthWorkerState(
        page: 2,
        healthWorkers: BasePagination<HealthWorkerModel>(
          data: <HealthWorkerModel>[
            HealthWorkerModel(
              id: '1',
            ),
          ],
          metadata: MetadataPaginationModel(
            total: 2,
            page: 1,
            perPage: 10,
          ),
        ),
      ),
      HealthWorkerState(
        page: 2,
        healthWorkers: BasePagination<HealthWorkerModel>(
          data: <HealthWorkerModel>[
            HealthWorkerModel(
              id: '1',
            ),
          ],
          metadata: MetadataPaginationModel(
            total: 2,
            page: 1,
            perPage: 10,
          ),
        ),
        statusGetHealthWorkers: FormzSubmissionStatus.inProgress,
      ),
      HealthWorkerState(
        page: 2,
        healthWorkers: BasePagination<HealthWorkerModel>(
          data: <HealthWorkerModel>[
            HealthWorkerModel(
              id: '1',
            ),
          ],
          metadata: MetadataPaginationModel(
            total: 2,
            page: 1,
            perPage: 10,
          ),
        ),
        statusGetHealthWorkers: FormzSubmissionStatus.success,
      ),
    ],
  );

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

  group('GetHealthWorkers', () {
    test('supports value comparisons', () {
      expect(GetHealthWorkers(), GetHealthWorkers());
    });
  });
}
