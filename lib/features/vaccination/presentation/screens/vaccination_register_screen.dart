import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:eimunisasi/features/vaccination/logic/blocs/appointmentBloc/appointment_bloc.dart';
import 'package:eimunisasi/models/nakes.dart';
import 'package:eimunisasi/core/widgets/button_custom.dart';
import 'package:eimunisasi/core/widgets/snackbar_custom.dart';
import 'package:eimunisasi/routers/route_paths/vaccination_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/picker.dart';

class VaccinationRegisterScreen extends StatelessWidget {
  final Anak anak;
  final Nakes nakes;

  const VaccinationRegisterScreen({
    Key? key,
    required this.anak,
    required this.nakes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentBloc(),
      child: _VaccinationRegisterScaffold(
        child: anak,
        healthWorker: nakes,
      ),
    );
  }
}

class _VaccinationRegisterScaffold extends StatefulWidget {
  final Anak child;
  final Nakes healthWorker;

  const _VaccinationRegisterScaffold({
    required this.child,
    required this.healthWorker,
  });

  @override
  State<_VaccinationRegisterScaffold> createState() =>
      _VaccinationRegisterScaffoldState();
}

class _VaccinationRegisterScaffoldState
    extends State<_VaccinationRegisterScaffold> {
  String _tanggal = 'Pilih tanggal';
  JadwalPraktek? selectedRadioTile;
  bool isLoading = false;

  final kFirstDay = DateTime.now();
  final kLastDay = DateTime(DateTime.now().year + 1);

  setSelectedRadioTile(JadwalPraktek? val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user =
        (context.read<AuthenticationBloc>().state as Authenticated).user;
    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state.statusSubmit == FormzSubmissionStatus.success) {
          context.push(
            VaccinationRoutePaths.vaccinationConfirmation.fullPath,
            extra: state.appointment,
          );
        } else if (state.statusSubmit == FormzSubmissionStatus.failure) {
          snackbarCustom(
            AppConstant.MAKE_APPOINTMENT_FAILED,
          ).show(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            AppConstant.MAKE_APPOINTMENT,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: SizedBox.expand(
          child: Container(
            color: Colors.pink[100],
            child: Card(
              margin: EdgeInsets.all(20),
              elevation: 0,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Nakes: ' +
                            (widget.healthWorker.namaLengkap ?? '-'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Jadwal Praktek',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ...?widget.healthWorker.jadwal?.map((jadwal) {
                        return Column(
                          children: [
                            Text(
                              (jadwal.hari?.capitalize() ?? '') +
                                  ', ' +
                                  (jadwal.jam ?? ''),
                            ),
                            SizedBox(height: 5),
                          ],
                        );
                      }).toList(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Jadwal Praktek Imunisasi',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Column(
                        children: () {
                          final jadwalImunisasi =
                              widget.healthWorker.jadwalImunisasi;
                          if (jadwalImunisasi == null) {
                            return Text('Belum ada jadwal imunisasi');
                          } else {
                            return jadwalImunisasi
                                .map(
                                  (e) => RadioListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.all(0),
                                    value: e,
                                    groupValue: selectedRadioTile,
                                    title: Text(
                                      e.hari!.capitalize() + ', ' + e.jam!,
                                    ),
                                    onChanged: setSelectedRadioTile,
                                  ),
                                )
                                .toList();
                          }
                        }() as List<Widget>,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[300]!, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        dense: true,
                        onTap: () async {
                          final date = await Picker.pickDate(context);
                          if (date != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(date);
                            setState(() {
                              _tanggal = formattedDate.toString();
                            });
                          }
                        },
                        trailing: Icon(
                          Icons.date_range,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(_tanggal),
                      ),
                      SizedBox(height: 30),
                      ButtonCustom(
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  isLoading = true;
                                });
                                if (selectedRadioTile == null ||
                                    _tanggal == 'Pilih tanggal') {
                                  snackbarCustom(
                                    'Lengkapi data terlebih dahulu!',
                                  ).show(context);
                                  return;
                                }
                                final appointment = AppointmentModel(
                                  date: DateTime.parse(_tanggal),
                                  child: widget.child,
                                  parent: user,
                                  healthWorker: widget.healthWorker,
                                  purpose: 'Imunisasi',
                                  note: 'Imunisasi',
                                );
                                try {
                                  // TODO: FIX THIS
                                  context.read<AppointmentBloc>().add(
                                        CreateAppointment(appointment),
                                      );
                                } catch (e) {
                                  snackbarCustom(
                                    AppConstant.MAKE_APPOINTMENT_FAILED,
                                  ).show(context);
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                'Buat Janji',
                                style: TextStyle(color: Colors.white),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
