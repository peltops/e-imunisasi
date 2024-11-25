part of 'health_worker_bloc.dart';

class HealthWorkerState extends Equatable {
  final int page;
  final int perPage;
  final String? search;
  final List<HealthWorkerModel> healthWorkers;
  final FormzSubmissionStatus statusGetHealthWorkers;

  const HealthWorkerState({
    this.page = 1,
    this.perPage = 20,
    this.search,
    this.healthWorkers = const [],
    this.statusGetHealthWorkers = FormzSubmissionStatus.initial,
  });

  copyWith({
    int? page,
    int? perPage,
    String? search,
    List<HealthWorkerModel>? healthWorkers,
    FormzSubmissionStatus? statusGetHealthWorkers,
  }) {
    return HealthWorkerState(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      healthWorkers: healthWorkers ?? this.healthWorkers,
      statusGetHealthWorkers: statusGetHealthWorkers ?? this.statusGetHealthWorkers,
    );
  }

  @override
  List<Object?> get props => [
    page,
    perPage,
    search,
    healthWorkers,
    statusGetHealthWorkers,
  ];
}
