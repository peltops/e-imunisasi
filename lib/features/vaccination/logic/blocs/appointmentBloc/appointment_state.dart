part of 'appointment_bloc.dart';

class AppointmentState extends Equatable {
  const AppointmentState({
    this.appointment,
    this.getAppointments = const [],
    this.statusSubmit = FormzSubmissionStatus.initial,
    this.statusGet = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final AppointmentModel? appointment;
  final List<AppointmentModel> getAppointments;
  final FormzSubmissionStatus statusSubmit;
  final FormzSubmissionStatus statusGet;
  final String? errorMessage;

  AppointmentState copyWith({
    AppointmentModel? appointment,
    List<AppointmentModel>? getAppointments,
    FormzSubmissionStatus? statusSubmit,
    FormzSubmissionStatus? statusGet,
    String? errorMessage,
  }) {
    return AppointmentState(
      appointment: appointment ?? this.appointment,
      getAppointments: getAppointments ?? this.getAppointments,
      statusSubmit: statusSubmit ?? this.statusSubmit,
      statusGet: statusGet ?? this.statusGet,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    appointment,
    getAppointments,
    statusSubmit,
    statusGet,
    errorMessage,
  ];
}

