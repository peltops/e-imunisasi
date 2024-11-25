part of 'clinic_bloc.dart';

sealed class ClinicEvent extends Equatable {
  const ClinicEvent();
}


class ChangePage extends ClinicEvent {
  final int page;

  const ChangePage(this.page);

  @override
  List<Object> get props => [page];
}

class ChangeSearch extends ClinicEvent {
  final String search;

  const ChangeSearch(this.search);

  @override
  List<Object> get props => [search];
}

class GetClinics extends ClinicEvent {
  const GetClinics();

  @override
  List<Object> get props => [];
}