import 'package:bloc/bloc.dart';
import 'package:eimunisasi/core/models/pagination_model.dart';
import 'package:eimunisasi/features/health_worker/data/models/clinic_model.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/clinic_repository.dart';

part 'clinic_event.dart';

part 'clinic_state.dart';

@injectable
class ClinicBloc extends Bloc<ClinicEvent, ClinicState> {
  final ClinicRepository clinicRepository;

  ClinicBloc(
    this.clinicRepository,
  ) : super(ClinicState()) {
    on<ChangePage>(_onChangePage);
    on<ChangeSearch>(_onChangeSearch);
    on<GetClinics>(_onGetClinics);
  }

  void _onChangePage(ChangePage event, Emitter<ClinicState> emit) {
    if ((state.clinics.data?.length ?? 0) >=
            (state.clinics.metadata?.total ?? 0) &&
        event.page != 1) {
      return;
    }
    emit(state.copyWith(page: event.page));
    add(GetClinics());
  }

  void _onChangeSearch(ChangeSearch event, Emitter<ClinicState> emit) {
    emit(state.copyWith(
      search: event.search,
      page: 1,
    ));
    add(GetClinics());
  }

  void _onGetClinics(GetClinics event, Emitter<ClinicState> emit) async {
    emit(state.copyWith(statusGetClinic: FormzSubmissionStatus.inProgress));
    try {
      final clinics = await clinicRepository.getClinics(
        page: state.page,
        perPage: state.perPage,
        search: state.search,
      );
      emit(
        state.copyWith(
          clinics: BasePagination<ClinicModel>(
            data: state.page == 1
                ? clinics.data
                : [
                    ...?state.clinics.data,
                    ...?clinics.data,
                  ],
            metadata: clinics.metadata,
          ),
          statusGetClinic: FormzSubmissionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          statusGetClinic: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}
