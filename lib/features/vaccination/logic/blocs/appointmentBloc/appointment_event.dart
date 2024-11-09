part of 'appointment_bloc.dart';

sealed class AppointmentEvent extends Equatable {
  const AppointmentEvent();
}

class LoadAppointmentsEvent extends AppointmentEvent {
  final String userId;
  const LoadAppointmentsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateAppointmentEvent extends AppointmentEvent {
  final AppointmentModel appointment;
  const CreateAppointmentEvent(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class UpdateAppointmentEvent extends AppointmentEvent {
  final AppointmentModel appointment;
  const UpdateAppointmentEvent(this.appointment);

  @override
  List<Object?> get props => [appointment];
}
