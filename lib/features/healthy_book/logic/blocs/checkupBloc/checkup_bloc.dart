import 'package:bloc/bloc.dart';
import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repositories/checkup_repository.dart';

part 'checkup_event.dart';
part 'checkup_state.dart';

@injectable
class CheckupBloc extends Bloc<CheckupEvent, CheckupState> {
  final CheckupRepository repository;
  CheckupBloc(this.repository) : super(CheckupState()) {
    on<OnGetCheckupsEvent>(_onGetCheckups);
  }
  void _onGetCheckups(
      OnGetCheckupsEvent event, Emitter<CheckupState> emit) async {
    emit(state.copyWith(statusGet: FormzSubmissionStatus.inProgress));
    try {
      if (event.childId == null) {
        throw 'Child ID must not be null';
      }
      final checkups = await repository.getCheckups(event.childId!);
      emit(state.copyWith(
        statusGet: FormzSubmissionStatus.success,
        checkups: checkups,
      ));
    } catch (e) {
      emit(state.copyWith(
        statusGet: FormzSubmissionStatus.failure,
        errorMessage: "Gagal mendapatkan data",
      ));
    }
  }
}
