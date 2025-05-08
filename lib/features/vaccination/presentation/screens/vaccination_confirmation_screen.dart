import 'dart:developer';

import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/core/widgets/button_custom.dart';
import 'package:eimunisasi/core/widgets/error.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/snackbar_custom.dart';
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
          final appointment = state.getAppointmentWithOrder?.appointment;
          final order = state.getAppointmentWithOrder?.order;
          final date = () {
            if (appointment?.date == null) {
              return emptyString;
            }
            return DateFormat('dd MMMM yyyy').format(appointment!.date!);
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
                          data: appointment?.id ?? '',
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
                                appointment?.child?.nama ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                appointment?.child?.umurAnak ?? '',
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
                                appointment?.healthWorker?.fullName ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                appointment?.healthWorker?.profession ?? '',
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                appointment?.time ?? '',
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Create detail order UI
                      SizedBox(height: 20),
                      Text(
                        'Detail Pesanan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Berikut adalah detail pesanan anda',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 10),
                      Table(
                        children: [
                          TableRow(
                            children: [
                              Text(
                                'ID Pesanan :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                order?.id ?? '',
                              ),
                            ],
                          ),
                          ...?order?.orderItems?.map(
                            (item) => TableRow(
                              children: [
                                Text(
                                  item.product?.name ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '${item.price} x ${item.quantity}',
                                ),
                              ],
                            ),
                          ),
                          TableRow(
                            children: [
                              Text(
                                'Status Pesanan :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                order?.status ?? '',
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                'Total Pembayaran :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                order?.totalAmount.toString() ?? '',
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      if (order?.status == 'draft') ...[
                        Row(
                          children: [
                            Expanded(
                              child: ButtonCustom(
                                onPressed: () async {
                                  final payment = order?.payment;
                                  final gateway = payment?.gateway;
                                  try {
                                    if (gateway == 'midtrans') {
                                      final paymentUrl =
                                          payment?.redirectUrl ?? '';
                                      final paymentUri = Uri.parse(paymentUrl);
                                      if (await canLaunchUrl(paymentUri)) {
                                        await launchUrl(paymentUri);
                                      } else {
                                        snackbarCustom(
                                          'Terjadi kesalahan saat melakukan pembayaran',
                                        ).show(context);
                                      }
                                    } else if (gateway == 'stripe') {
                                      await stripe.Stripe.instance
                                          .initPaymentSheet(
                                        paymentSheetParameters:
                                            stripe.SetupPaymentSheetParameters(
                                          paymentIntentClientSecret:
                                              payment?.token,
                                          customFlow: false,
                                          style: ThemeMode.light,
                                          merchantDisplayName: 'E-Imunisasi',
                                        ),
                                      );
                                      await stripe.Stripe.instance
                                          .presentPaymentSheet();
                                    }
                                    context.read<AppointmentBloc>().add(
                                          LoadAppointmentEvent(appointmentId),
                                        );
                                  } catch (e) {
                                    log('Error launching payment: $e');
                                    snackbarCustom(
                                      'Terjadi kesalahan saat melakukan pembayaran',
                                    ).show(context);
                                  }
                                },
                                child: Text(
                                  'Bayar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ButtonCustom(
                                child: Text(
                                  'Check Status',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  context.read<AppointmentBloc>().add(
                                        LoadAppointmentEvent(appointmentId),
                                      );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 15),
                      ButtonCustom(
                        onPressed: () {
                          context.pushReplacement(
                            RootRoutePaths.dashboard.fullPath,
                          );
                        },
                        child: Text(
                          'Halaman Utama',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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
