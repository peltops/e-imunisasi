import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/core/widgets/button_custom.dart';
import 'package:eimunisasi/core/widgets/error.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

import '../../logic/blocs/appointmentBloc/appointment_bloc.dart';

class VaccinationConfirmationScreen extends StatelessWidget {
  final String appointmentId;

  const VaccinationConfirmationScreen({
    Key? key,
    required this.appointmentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppointmentBloc>()
        ..add(
          LoadAppointmentEvent(appointmentId),
        ),
      child: _VaccinationConfirmationScaffold(
        appointmentId,
      ),
    );
  }
}

class _VaccinationConfirmationScaffold extends StatelessWidget {
  final String appointmentId;

  const _VaccinationConfirmationScaffold(
    this.appointmentId,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(
              RootRoutePaths.dashboard.fullPath,
            );
          },
        ),
        title: Text(
          AppConstant.APPOINTMENT,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state.statusGetAppointment == FormzSubmissionStatus.inProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.statusGetAppointment == FormzSubmissionStatus.failure) {
            return ErrorContainer(
              message: state.errorMessage,
              onRefresh: () {
                context.read<AppointmentBloc>().add(
                      LoadAppointmentEvent(appointmentId),
                    );
              },
            );
          }
          final date = () {
            if (state.getAppointment?.date == null) {
              return emptyString;
            }
            return DateFormat('dd MMMM yyyy')
                .format(state.getAppointment!.date!);
          }();
          return Container(
            color: Colors.pink[100],
            child: Card(
              margin: EdgeInsets.all(20),
              elevation: 0,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: QrImageView(
                          data: state.getAppointment?.id ?? '',
                          size: size.width * 0.5,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Konfirmasi Janji',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Janji dengan Nakes telah dibuat. Lihat detail Informasi berikut: ',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.pink[300],
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.getAppointment?.child?.nama ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                state.getAppointment?.child?.umurAnak ?? '',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.pink[300],
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.getAppointment?.healthWorker?.fullName ??
                                    '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                state.getAppointment?.healthWorker
                                        ?.profession ??
                                    '',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Table(
                        children: [
                          TableRow(
                            children: [
                              Text(
                                'Tanggal :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                date,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                'Jam :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                (state.getAppointment?.startTime ?? '') +
                                    ' - ' +
                                    (state.getAppointment?.endTime ?? ''),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      ButtonCustom(
                        onPressed: () {
                          context.go(
                            RootRoutePaths.dashboard.fullPath,
                          );
                        },
                        child: Text(
                          'Halaman Utama',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
