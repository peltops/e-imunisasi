import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:eimunisasi/features/profile/data/models/child_model.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:eimunisasi/features/vaccination/logic/blocs/appointmentBloc/appointment_bloc.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/core/widgets/button_custom.dart';
import 'package:eimunisasi/core/widgets/snackbar_custom.dart';
import 'package:eimunisasi/routers/route_paths/vaccination_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/picker.dart';
import '../../../payment/data/models/payment_initiate_request_model.dart';
import '../../../payment/logic/blocs/payment_bloc/payment_bloc.dart';

class VaccinationRegisterScreen extends StatelessWidget {
  final ChildModel anak;
  final HealthWorkerModel nakes;

  const VaccinationRegisterScreen({
    Key? key,
    required this.anak,
    required this.nakes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AppointmentBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<PaymentBloc>(),
        ),
      ],
      child: _VaccinationRegisterScaffold(
        child: anak,
        healthWorker: nakes,
      ),
    );
  }
}

class _VaccinationRegisterScaffold extends StatefulWidget {
  final ChildModel child;
  final HealthWorkerModel healthWorker;

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
  DateTime? _selectedDate;
  Schedule? selectedRadioTile;
  String? _note;

  final kFirstDay = DateTime.now().add(Duration(days: 1));
  final kLastDay = DateTime(DateTime.now().year + 1);

  setSelectedRadioTile(Schedule? val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  setNoteValue(String val) {
    setState(() {
      _note = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user =
        (context.read<AuthenticationBloc>().state as Authenticated).user;

    void onSubmit() {
      if (selectedRadioTile == null || _selectedDate == null) {
        snackbarCustom(
          'Lengkapi data terlebih dahulu!',
        ).show(context);
        return;
      }

      context.read<PaymentBloc>().add(
            InitiatePaymentEvent(
              PaymentInitiateRequestModel(
                currency: 'idr',
                items: [
                  ItemModel(
                    /// This is booking fee ID
                    id: '4cf70de1-35d6-4794-a249-9b79c328f086',
                    quantity: 1,
                  ),
                ],
              ),
            ),
          );
      final appointment = AppointmentModel(
        date: _selectedDate,
        child: widget.child,
        parent: user,
        healthWorker: widget.healthWorker,
        purpose: 'Imunisasi',
        note: _note,
        startTime: selectedRadioTile?.startTime,
        endTime: selectedRadioTile?.endTime,
      );
      context.read<AppointmentBloc>().add(
            CreateAppointmentEvent(appointment),
          );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<AppointmentBloc, AppointmentState>(
          listener: (context, state) {
            if (state.statusSubmit == FormzSubmissionStatus.success) {
              context.go(
                VaccinationRoutePaths.vaccinationConfirmation.fullPath,
                extra: state.appointment?.id,
              );
            } else if (state.statusSubmit == FormzSubmissionStatus.failure) {
              snackbarCustom(
                AppConstant.MAKE_APPOINTMENT_FAILED,
              ).show(context);
            }
          },
        ),
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentFailure) {
              snackbarCustom(
                'Terjadi kesalahan saat melakukan pembayaran',
              ).show(context);
            } else if (state is PaymentInitiateSuccess) {
              final gateway = state.response.data?.gateway;
              if (gateway == 'midtrans') {
                final paymentUrl = state.response.data?.redirectUrl ?? '';
                final paymentUri = Uri.parse(paymentUrl);
                launchUrl(paymentUri);
              } else if (gateway == 'stripe') {
                // TODO: handle with https://pub.dev/packages/flutter_stripe
              }
            }
          },
        ),
      ],
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
        body: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            return SizedBox.expand(
              child: Container(
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
                          Text(
                            'Nama Nakes: ' +
                                (widget.healthWorker.fullName ?? '-'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ...?widget.healthWorker.schedules?.map((schedule) {
                            final day = schedule.day?.name;
                            return Column(
                              children: [
                                Text(
                                  '$day, ${schedule.time}',
                                ),
                                SizedBox(height: 5),
                              ],
                            );
                          }).toList(),
                          SizedBox(height: 20),
                          TextField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: _selectedDate == null
                                    ? null
                                    : DateFormat('dd MMMM yyyy')
                                        .format(_selectedDate!)),
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.date_range),
                              suffixIconColor: Colors.pink,
                              labelText: 'Tanggal',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink,
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onTap: () async {
                              final date = await Picker.pickDate(
                                context,
                                currentTime: () {
                                  final days = widget
                                      .healthWorker.practiceSchedules
                                      ?.map((e) => e.day?.id)
                                      .whereType<int>()
                                      .toList();

                                  if (days == null || days.isEmpty) {
                                    return null;
                                  }

                                  final tomorrowDate =
                                      DateTime.now().add(Duration(days: 1));
                                  final tomorrow = tomorrowDate.weekday;

                                  final nextAvailableDay = days.firstWhere(
                                    (element) => element >= tomorrow,
                                    orElse: () => days.first,
                                  );

                                  final difference =
                                      (nextAvailableDay - tomorrow) % 7;
                                  return tomorrowDate
                                      .add(Duration(days: difference));
                                }(),
                                maxTime: kLastDay,
                                minTime: kFirstDay,
                                selectableDayPredicate: (DateTime day) {
                                  final daySchedule = widget
                                      .healthWorker.practiceSchedules
                                      ?.where((element) {
                                    return element.day?.id == day.weekday;
                                  });
                                  return daySchedule?.isNotEmpty ?? false;
                                },
                              );
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Jadwal Praktek Imunisasi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Column(
                            children: () {
                              if (_selectedDate == null) {
                                return [
                                  Text('Pilih tanggal terlebih dahulu'),
                                ];
                              }
                              final schedules =
                                  widget.healthWorker.practiceSchedules;
                              if (schedules == null || schedules.isEmpty) {
                                return Text('Belum ada jadwal imunisasi');
                              }
                              return schedules.where(
                                (element) {
                                  return element.day?.id ==
                                      _selectedDate?.weekday;
                                },
                              ).map(
                                (e) {
                                  final day = e.day?.name;
                                  return RadioListTile<Schedule>(
                                    dense: true,
                                    contentPadding: EdgeInsets.all(0),
                                    value: e,
                                    groupValue: selectedRadioTile,
                                    title: Text(
                                      '$day, ${e.time}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    onChanged: setSelectedRadioTile,
                                  );
                                },
                              ).toList();
                            }() as List<Widget>,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            onChanged: setNoteValue,
                            maxLines: null,
                            minLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Catatan (Opsional)',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink,
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ListTile(
                            title: Text(
                              'Booking Fee: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              'Rp. ${widget.healthWorker.bookingFee}',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          ButtonCustom(
                            loading: state.statusSubmit ==
                                FormzSubmissionStatus.inProgress,
                            onPressed: onSubmit,
                            child: Text(
                              'Bayar dan Buat Janji',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
