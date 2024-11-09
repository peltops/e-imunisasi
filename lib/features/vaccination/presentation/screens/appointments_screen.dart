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
        color: Colors.pink[100],
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    child: BlocBuilder<AppointmentBloc, AppointmentState>(
                      builder: (context, state) {
                        if (state.statusGet ==
                            FormzSubmissionStatus.inProgress) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final data = state.getAppointments;
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final appointment = data[index];
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  context.push(
                                    VaccinationRoutePaths
                                        .vaccinationConfirmation.fullPath,
                                    extra: appointment,
                                  );
                                },
                                title: Text(
                                  (appointment.child?.nama ?? '') +
                                      ' ' +
                                      (appointment.child?.umurAnak ?? ''),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('dd MMMM yyyy')
                                      .format(appointment.date!),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
