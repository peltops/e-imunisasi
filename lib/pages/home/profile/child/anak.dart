import 'dart:ui';

import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/anak_database.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AnakPage extends StatefulWidget {
  final nama, nik, tempatLahir, tanggalLahir, jenisKelamin, golDarah, indexAnak;
  const AnakPage({
    Key key,
    @required this.nama,
    @required this.nik,
    @required this.tempatLahir,
    @required this.tanggalLahir,
    @required this.jenisKelamin,
    @required this.golDarah,
    @required this.indexAnak,
  }) : super(key: key);

  @override
  _AnakPageState createState() => _AnakPageState();
}

class _AnakPageState extends State<AnakPage> {
  TextEditingController _namaCtrl,
      _nikCtrl,
      _tempatLahirCtrl,
      _tanggalLahirCtrl,
      _jenisKelaminCtrl,
      _golDarahCtrl;

  @override
  void initState() {
    print(widget.indexAnak);
    DateTime _tanggalLahir =
        DateTime.parse(widget.tanggalLahir.toDate().toString());

    _namaCtrl = TextEditingController(text: widget.nama);
    _nikCtrl = TextEditingController(text: widget.nik);
    _tempatLahirCtrl = TextEditingController(text: widget.tempatLahir);
    _tanggalLahirCtrl = TextEditingController(
        text: DateFormat('dd-MM-yyyy').format(_tanggalLahir).toString());
    _jenisKelaminCtrl = TextEditingController(text: widget.jenisKelamin);
    _golDarahCtrl = TextEditingController(text: widget.golDarah);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kFirstDay = DateTime(DateTime.now().year - 5);
    final kLastDay = DateTime.now();
    bool loading = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Profil',
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
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 6,
                child: Card(
                  elevation: 0,
                  child: Center(child: Text(_namaCtrl.text)),
                ),
              ),
              Expanded(
                  child: Container(
                      width: double.infinity,
                      child: Card(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextFormCustom(
                                  initialValue: _namaCtrl.text,
                                  label: 'Nama Lengkap',
                                  onChanged: (val) {
                                    _namaCtrl.text = val;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextFormCustom(
                                  initialValue: _nikCtrl.text,
                                  keyboardType: TextInputType.number,
                                  label: 'NIK',
                                  onChanged: (val) {
                                    _nikCtrl.text = val;
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: TextFormCustom(
                                        initialValue: _tempatLahirCtrl.text,
                                        label: 'Tempat Lahir',
                                        onChanged: (val) {},
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: TextFormCustom(
                                        onTap: () => DatePicker.showDatePicker(
                                            context,
                                            theme: DatePickerTheme(
                                              doneStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            ),
                                            showTitleActions: true,
                                            minTime: kFirstDay,
                                            maxTime: kLastDay,
                                            onConfirm: (val) {
                                          String formattedDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(val);
                                          setState(() {
                                            _tanggalLahirCtrl.text =
                                                formattedDate.toString();
                                          });
                                        },
                                            currentTime:
                                                widget.tanggalLahir.toDate(),
                                            locale: LocaleType.id),
                                        readOnly: true,
                                        label: 'Tanggal Lahir',
                                        controller: _tanggalLahirCtrl,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextFormCustom(
                                  initialValue: _jenisKelaminCtrl.text,
                                  label: 'Jenis Kelamin',
                                  onChanged: (val) {
                                    setState(() {
                                      // password = val;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextFormCustom(
                                  initialValue: _golDarahCtrl.text,
                                  label: 'Golongan Darah',
                                  onChanged: (val) {
                                    setState(() {
                                      // password = val;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: buttonCustom(
                                  textChild: !loading
                                      ? Text(
                                          "Simpan",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white),
                                        )
                                      : SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                  onPressed: !loading
                                      ? () async {
                                          DateTime tempDate = new DateFormat(
                                                  "dd-MM-yyyy")
                                              .parse(_tanggalLahirCtrl.text);
                                          dismissKeyboard(context);
                                          setState(() {
                                            loading = true;
                                          });
                                          try {
                                            AnakService()
                                                .setData(
                                                    Anak(
                                                        _nikCtrl.text,
                                                        _tempatLahirCtrl.text,
                                                        _jenisKelaminCtrl.text,
                                                        _golDarahCtrl.text,
                                                        _namaCtrl.text,
                                                        tempDate),
                                                    widget.indexAnak)
                                                .then((value) {
                                                  snackbarCustom(
                                                          'Data anak berhasil diperbarui')
                                                      .show(context);

                                                  Navigator.pop(context);
                                                })
                                                .catchError((onError) =>
                                                    snackbarCustom(
                                                            'Terjadi kesalahan: $onError')
                                                        .show(context))
                                                .whenComplete(
                                                    () => setState(() {
                                                          loading = false;
                                                        }));
                                          } catch (e) {
                                            snackbarCustom(e.message.toString())
                                                .show(context);
                                          }
                                        }
                                      : null,
                                ),
                              )
                            ],
                          ),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
