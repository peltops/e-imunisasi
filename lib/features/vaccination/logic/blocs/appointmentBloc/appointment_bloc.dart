import 'package:bloc/bloc.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../../profile/data/models/anak.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(AppointmentState()) {
    on<AppointmentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
