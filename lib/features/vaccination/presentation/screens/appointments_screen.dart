import 'package:eimunisasi/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:eimunisasi/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../routers/route_paths/vaccination_route_paths.dart';
import '../../logic/blocs/appointmentBloc/appointment_bloc.dart';

class AppointmentsScreen extends StatelessWidget {
  final page;

  const AppointmentsScreen({Key? key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? userId = (context.read<AuthenticationBloc>().state
            is Authenticated)
        ? (context.read<AuthenticationBloc>().state as Authenticated).user.uid
        : '';
    return BlocProvider(
      create: (context) => getIt<AppointmentBloc>()
        ..add(
          LoadAppointmentsEvent(userId ?? ''),
        ),
      child: _AppointmentsScaffold(),
    );
  }
}

class _AppointmentsScaffold extends StatelessWidget {
  const _AppointmentsScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Pilih Janji',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(20),
        color: Colors.pink[100],
        child: Column(
          children: [
            BlocConsumer<AppointmentBloc, AppointmentState>(
              listenWhen: (previous, current) =>
                  previous.sortCriteria != current.sortCriteria,
              listener: (context, state) {
                final userId = (context.read<AuthenticationBloc>().state
                        as Authenticated)
                    .user
                    .uid ?? '';
                context.read<AppointmentBloc>().add(
                      LoadAppointmentsEvent(
                        userId,
                      ),
                    );
              },
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Urutkan berdasarkan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: state.sortCriteria,
                      onChanged: (String? newValue) {
                        context.read<AppointmentBloc>().add(
                              ChangeSortCriteriaEvent(newValue),
                            );
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'date',
                          child: Text('Tanggal'),
                        ),
                        DropdownMenuItem(
                          value: 'name',
                          child: Text('Nama'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            Expanded(
              child: Card(
                elevation: 0,
                child: BlocBuilder<AppointmentBloc, AppointmentState>(
                  builder: (context, state) {
                    if (state.statusGetAppointments ==
                        FormzSubmissionStatus.inProgress) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final data = state.getAppointments;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final appointment = data[index];
                        return _ListAppointment(
                          appointment,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListAppointment extends StatelessWidget {
  final AppointmentModel appointment;

  const _ListAppointment(this.appointment);

  @override
  Widget build(BuildContext context) {
    final name = appointment.child?.nama ?? '';
    final age = appointment.child?.umurAnak ?? '';
    final date = () {
      if (appointment.date == null) {
        return '';
      }
      return DateFormat('dd MMMM yyyy').format(appointment.date!);
    }();
    return Card(
      child: ListTile(
        onTap: () {
          context.push(
            VaccinationRoutePaths.vaccinationConfirmation.fullPath,
            extra: appointment.id,
          );
        },
        title: Text(
          "$name ($age)",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          date,
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right_rounded,
        ),
      ),
    );
  }
}
