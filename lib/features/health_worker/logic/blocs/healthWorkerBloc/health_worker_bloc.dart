import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/health_worker_model.dart';
import '../../../data/repositories/health_worker_repository.dart';

part 'health_worker_event.dart';

part 'health_worker_state.dart';

@injectable
class HealthWorkerBloc extends Bloc<HealthWorkerEvent, HealthWorkerState> {
  final HealthWorkerRepository healthWorkerRepository;

  HealthWorkerBloc(
    this.healthWorkerRepository,
  ) : super(HealthWorkerState()) {
    on<GetHealthWorkers>(_onGetHealthWorkers);
    on<ChangePage>(_onChangePage);
    on<ChangeSearch>(_onChangeSearch);
  }

  void _onGetHealthWorkers(
      GetHealthWorkers event, Emitter<HealthWorkerState> emit) async {
    emit(state.copyWith(
        statusGetHealthWorkers: FormzSubmissionStatus.inProgress));
    try {
      final healthWorkers = await healthWorkerRepository.getHealthWorkers(
        page: state.page,
        perPage: state.perPage,
        search: state.search,
      );
      emit(state.copyWith(
        healthWorkers: () {
          if (state.page == 1) {
            return healthWorkers;
          } else {
            return [...state.healthWorkers, ...healthWorkers];
          }
        }(),
        statusGetHealthWorkers: FormzSubmissionStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          statusGetHealthWorkers: FormzSubmissionStatus.failure));
    }
  }

  void _onChangePage(ChangePage event, Emitter<HealthWorkerState> emit) {
    emit(state.copyWith(page: event.page));
    add(GetHealthWorkers());
  }

  void _onChangeSearch(ChangeSearch event, Emitter<HealthWorkerState> emit) {
    emit(state.copyWith(
      search: event.search,
      page: 1,
    ));
    add(GetHealthWorkers());
  }
}
