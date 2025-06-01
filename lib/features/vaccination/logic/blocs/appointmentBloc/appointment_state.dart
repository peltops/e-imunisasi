part of 'appointment_bloc.dart';

class AppointmentState extends Equatable {
  const AppointmentState({
    this.sortCriteria = 'date',
    this.appointmentWithOrder,
    this.getAppointmentWithOrder,
    this.getAppointments = const [],
    this.statusSubmit = FormzSubmissionStatus.initial,
    this.statusGetAppointments = FormzSubmissionStatus.initial,
    this.statusGetAppointment = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final String sortCriteria;
  final AppointmentOrderEntity? appointmentWithOrder;
  final AppointmentOrderEntity? getAppointmentWithOrder;
  final List<AppointmentModel> getAppointments;
  final FormzSubmissionStatus statusSubmit;
  final FormzSubmissionStatus statusGetAppointments;
  final FormzSubmissionStatus statusGetAppointment;
  final String? errorMessage;

  AppointmentState copyWith({
    String? sortCriteria,
    AppointmentOrderEntity? appointmentWithOrder,
    AppointmentOrderEntity? getAppointmentWithOrder,
    List<AppointmentModel>? getAppointments,
    FormzSubmissionStatus? statusSubmit,
    FormzSubmissionStatus? statusGetAppointments,
    FormzSubmissionStatus? statusGetAppointment,
    String? errorMessage,
  }) {
    return AppointmentState(
      sortCriteria: sortCriteria ?? this.sortCriteria,
      appointmentWithOrder: appointmentWithOrder ?? this.appointmentWithOrder,
      getAppointmentWithOrder:
          getAppointmentWithOrder ?? this.getAppointmentWithOrder,
      getAppointments: getAppointments ?? this.getAppointments,
      statusSubmit: statusSubmit ?? this.statusSubmit,
      statusGetAppointment: statusGetAppointment ?? this.statusGetAppointment,
      statusGetAppointments:
          statusGetAppointments ?? this.statusGetAppointments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        sortCriteria,
        appointmentWithOrder,
        getAppointmentWithOrder,
        getAppointments,
        statusSubmit,
        statusGetAppointment,
        statusGetAppointments,
        errorMessage,
      ];
}
