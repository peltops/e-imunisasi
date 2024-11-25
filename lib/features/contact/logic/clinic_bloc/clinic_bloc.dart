import 'package:bloc/bloc.dart';
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
    emit(state.copyWith(page: event.page));
  }

  void _onChangeSearch(ChangeSearch event, Emitter<ClinicState> emit) {
    emit(state.copyWith(search: event.search));
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
          clinics: clinics,
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
