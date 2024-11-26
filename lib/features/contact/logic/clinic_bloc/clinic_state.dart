part of 'clinic_bloc.dart';

class ClinicState extends Equatable {
  final int page;
  final int perPage;
  final String? search;
  final BasePagination<ClinicModel> clinics;
  final FormzSubmissionStatus statusGetClinic;

  const ClinicState({
    this.page = 1,
    this.perPage = 10,
    this.search,
    this.clinics = const BasePagination<ClinicModel>(),
    this.statusGetClinic = FormzSubmissionStatus.initial,
  });

  ClinicState copyWith({
    int? page,
    int? perPage,
    String? search,
    BasePagination<ClinicModel>? clinics,
    FormzSubmissionStatus? statusGetClinic,
  }) {
    return ClinicState(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      clinics: clinics ?? this.clinics,
      statusGetClinic:
          statusGetClinic ?? this.statusGetClinic,
    );
  }

  @override
  List<Object?> get props => [
        page,
        perPage,
        search,
        clinics,
        statusGetClinic,
      ];
}
