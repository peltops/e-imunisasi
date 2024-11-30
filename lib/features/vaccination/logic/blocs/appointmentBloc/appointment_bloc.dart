import 'package:bloc/bloc.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:eimunisasi/features/vaccination/data/repositories/appointment_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

part 'appointment_event.dart';

part 'appointment_state.dart';

@injectable
class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository appointmentRepository;

  AppointmentBloc(this.appointmentRepository) : super(AppointmentState()) {
    on<LoadAppointmentsEvent>(_onLoadAppointments);
    on<LoadAppointmentEvent>(_onLoadAppointment);
    on<CreateAppointmentEvent>(_onCreateAppointment);
    on<UpdateAppointmentEvent>(_onUpdateAppointment);
    on<ChangeSortCriteriaEvent>(_onChangeSortCriteria);
  }

  void _onLoadAppointments(
    LoadAppointmentsEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(
      statusGetAppointments: FormzSubmissionStatus.inProgress,
    ));
    try {
      final appointments = await appointmentRepository.getAppointments(
        userId: event.userId,
        sortCriteria: state.sortCriteria,
      );
      emit(state.copyWith(
        statusGetAppointments: FormzSubmissionStatus.success,
        getAppointments: appointments,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          statusGetAppointments: FormzSubmissionStatus.failure,
          errorMessage: 'Gagal memuat data janji',
        ),
      );
    }
  }

  void _onCreateAppointment(
    CreateAppointmentEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(statusSubmit: FormzSubmissionStatus.inProgress));
    try {
      final appointment = event.appointment;
      final result = await appointmentRepository.setAppointment(appointment);
      emit(state.copyWith(
        statusSubmit: FormzSubmissionStatus.success,
        appointment: result,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          statusSubmit: FormzSubmissionStatus.failure,
          errorMessage: 'Gagal membuat janji',
        ),
      );
    }
  }

  void _onUpdateAppointment(
    UpdateAppointmentEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(statusSubmit: FormzSubmissionStatus.inProgress));
    try {
      final appointment = event.appointment;
      final result = await appointmentRepository.updateAppointment(appointment);
      emit(state.copyWith(
        statusSubmit: FormzSubmissionStatus.success,
        appointment: result,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          statusSubmit: FormzSubmissionStatus.failure,
          errorMessage: 'Gagal mengubah janji',
        ),
      );
    }
  }

  void _onLoadAppointment(
    LoadAppointmentEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(statusGetAppointment: FormzSubmissionStatus.inProgress),
    );
    try {
      final appointment = await appointmentRepository.getAppointment(
        id: event.id,
      );
      emit(state.copyWith(
        statusGetAppointment: FormzSubmissionStatus.success,
        getAppointment: appointment,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          statusGetAppointment: FormzSubmissionStatus.failure,
          errorMessage: 'Gagal memuat data janji',
        ),
      );
    }
  }

  void _onChangeSortCriteria(
    ChangeSortCriteriaEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(sortCriteria: event.sortCriteria));
  }
}
