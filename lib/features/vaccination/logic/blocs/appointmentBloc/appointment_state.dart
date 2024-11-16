part of 'appointment_bloc.dart';

class AppointmentState extends Equatable {
  const AppointmentState({
    this.appointment,
    this.getAppointment,
    this.getAppointments = const [],
    this.statusSubmit = FormzSubmissionStatus.initial,
    this.statusGetAppointments = FormzSubmissionStatus.initial,
    this.statusGetAppointment = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final AppointmentModel? appointment;
  final AppointmentModel? getAppointment;
  final List<AppointmentModel> getAppointments;
  final FormzSubmissionStatus statusSubmit;
  final FormzSubmissionStatus statusGetAppointments;
  final FormzSubmissionStatus statusGetAppointment;
  final String? errorMessage;

  AppointmentState copyWith({
    AppointmentModel? appointment,
    AppointmentModel? getAppointment,
    List<AppointmentModel>? getAppointments,
    FormzSubmissionStatus? statusSubmit,
    FormzSubmissionStatus? statusGetAppointments,
    FormzSubmissionStatus? statusGetAppointment,
    String? errorMessage,
  }) {
    return AppointmentState(
      appointment: appointment ?? this.appointment,
      getAppointment: getAppointment ?? this.getAppointment,
      getAppointments: getAppointments ?? this.getAppointments,
      statusSubmit: statusSubmit ?? this.statusSubmit,
      statusGetAppointments: statusGetAppointments ?? this.statusGetAppointments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    appointment,
    getAppointment,
    getAppointments,
    statusSubmit,
    statusGetAppointment,
    statusGetAppointments,
    errorMessage,
  ];
}

