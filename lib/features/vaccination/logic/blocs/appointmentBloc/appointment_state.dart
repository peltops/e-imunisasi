part of 'appointment_bloc.dart';

class AppointmentState extends Equatable {
  const AppointmentState({
    this.appointment,
    this.statusSubmit = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final AppointmentModel? appointment;
  final FormzSubmissionStatus statusSubmit;
  final String? errorMessage;

  AppointmentState copyWith({
    AppointmentModel? appointment,
    FormzSubmissionStatus? statusSubmit,
    String? errorMessage,
  }) {
    return AppointmentState(
      appointment: appointment ?? this.appointment,
      statusSubmit: statusSubmit ?? this.statusSubmit,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    appointment,
    statusSubmit,
    errorMessage,
  ];
}

