import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/models/appointment.dart';
import 'package:eimunisasi/models/nakes.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/konfirmasi_janji.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/services/appointment_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DaftarVaksinasiPage extends StatefulWidget {
  final Anak anak;
  final Nakes nakes;
  const DaftarVaksinasiPage(
      {Key key, @required this.anak, @required this.nakes})
      : super(key: key);
  @override
  _DaftarVaksinasiPageState createState() => _DaftarVaksinasiPageState();
}

class _DaftarVaksinasiPageState extends State<DaftarVaksinasiPage> {
  String _tanggal = 'Pilih tanggal';
  JadwalPraktek selectedRadioTile;
  bool isLoading = false;

  final kFirstDay = DateTime.now();
  final kLastDay = DateTime(DateTime.now().year + 1);

  setSelectedRadioTile(JadwalPraktek val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            "Buat janji",
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Nakes: ' + widget.nakes.namaLengkap,
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
                        ...widget.nakes.jadwal.map((jadwal) {
                          return Column(
                            children: [
                              Text(
                                jadwal.hari.capitalize() + ', ' + jadwal.jam,
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
                                widget.nakes.jadwalImunisasi;
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
                                        e.hari.capitalize() + ', ' + e.jam,
                                      ),
                                      onChanged: setSelectedRadioTile,
                                    ),
                                  )
                                  .toList();
                            }
                          }(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(color: Colors.grey[300], width: 2),
                              borderRadius: BorderRadius.circular(5)),
                          dense: true,
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              theme: DatePickerTheme(
                                doneStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                ),
                                cancelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                  color: Colors.black,
                                ),
                                itemStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              showTitleActions: true,
                              minTime: kFirstDay,
                              maxTime: kLastDay,
                              onConfirm: (val) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(val);
                                setState(() {
                                  _tanggal = formattedDate.toString();
                                });
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.id,
                            );
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
                                            'Lengkapi data terlebih dahulu!')
                                        .show(context);
                                    return;
                                  }
                                  final appointment = AppointmentModel(
                                    tanggal: DateTime.parse(_tanggal),
                                    anak: widget.anak,
                                    orangtua: user,
                                    nakes: widget.nakes,
                                    tujuan: 'Imunisasi',
                                    desc: selectedRadioTile.hari +
                                        ', ' +
                                        selectedRadioTile.jam,
                                    notes: 'Imunisasi',
                                  );
                                  try {
                                    AppointmentService(uid: user.uid)
                                        .setAppointment(appointment)
                                        .then((value) => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    KonfirmasiVaksinasiPage(
                                                  appointment: value,
                                                ),
                                              ),
                                            ));
                                  } catch (e) {
                                    snackbarCustom(e.message.toString())
                                        .show(context);
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
              )),
        ));
  }
}
