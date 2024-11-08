part of 'appointment_bloc.dart';

sealed class AppointmentEvent extends Equatable {
  const AppointmentEvent();
}

class LoadAppointment extends AppointmentEvent {
  final String userId;
  const LoadAppointment(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateAppointment extends AppointmentEvent {
  final AppointmentModel appointment;

  const CreateAppointment(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class UpdateAppointment extends AppointmentEvent {
  final AppointmentModel appointment;

  const UpdateAppointment(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class DeleteAppointment extends AppointmentEvent {
  final AppointmentModel appointment;

  DeleteAppointment(this.appointment);

  @override
  List<Object?> get props => [appointment];
}
