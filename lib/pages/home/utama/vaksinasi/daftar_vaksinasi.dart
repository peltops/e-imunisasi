import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/models/jadwal_janji.dart';
import 'package:eimunisasi/models/nakes.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/konfirmasi_janji.dart';
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
  JadwalImunisasi selectedRadioTile;
  bool isLoading = false;

  final kFirstDay = DateTime.now();
  final kLastDay = DateTime(DateTime.now().year + 1);
  @override
  void initState() {
    super.initState();
  }

  setSelectedRadioTile(JadwalImunisasi val) {
    setState(() {
      selectedRadioTile = val;
    });
    print(selectedRadioTile.jam);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    final jadwal = widget.nakes.jadwal;
    List<String> jadwalPraktek = [];
    for (var i = 0; i < jadwal.length; i++) {
      final hari = jadwal.keys.elementAt(i);
      final jam = jadwal.values.elementAt(i);
      for (var j = 0; j < jam.length; j++) {
        jadwalPraktek.add('$hari, ${jam[j]}');
      }
    }
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
                        Text(jadwalPraktek.join('\n')),
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
                                      contentPadding: EdgeInsets.all(0),
                                      value: e,
                                      groupValue: selectedRadioTile,
                                      title: Text(e.hari + ', ' + e.jam),
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
                              borderRadius: BorderRadius.circular(10)),
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
                            size: 30,
                          ),
                          title: Text(_tanggal),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (selectedRadioTile == null ||
                                        _tanggal == 'Pilih tanggal') {
                                      snackbarCustom(
                                              'Lengkapi data terlebih dahulu!')
                                          .show(context);
                                      return;
                                    }
                                    final appointment = JadwalJanjiModel(
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
                                      setState(() {
                                        isLoading = true;
                                      });
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
                                : Text('Buat Janji'),
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
