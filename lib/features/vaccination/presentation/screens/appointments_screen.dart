import 'package:eimunisasi/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:eimunisasi/models/appointment.dart';
import 'package:eimunisasi/services/appointment_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../routers/route_paths/vaccination_route_paths.dart';

class AppointmentsScreen extends StatelessWidget {
  final page;

  const AppointmentsScreen({Key? key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = (context.watch<AuthenticationBloc>().state as Authenticated).user;
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
                    child: FutureBuilder<List<AppointmentModel>>(
                      future: AppointmentService(uid: currentUser.uid)
                          .getAppointment(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          if (data != null && data.length > 0) {
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
                                      appointment.anak!.nama! +
                                          ' (${appointment.anak!.umurAnak})',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    subtitle: Text(
                                      DateFormat('dd MMMM yyyy')
                                          .format(appointment.tanggal!),
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
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Center(
                          child: Text('Tidak ada data'),
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
