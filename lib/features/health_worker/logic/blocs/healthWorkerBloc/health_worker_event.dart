part of 'health_worker_bloc.dart';

sealed class HealthWorkerEvent extends Equatable {
  const HealthWorkerEvent();
}

class ChangePage extends HealthWorkerEvent {
  final int page;

  const ChangePage(this.page);

  @override
  List<Object> get props => [page];
}

class ChangeSearch extends HealthWorkerEvent {
  final String search;

  const ChangeSearch(this.search);

  @override
  List<Object> get props => [search];
}

class GetHealthWorkers extends HealthWorkerEvent {
  const GetHealthWorkers();

  @override
  List<Object> get props => [];
}
