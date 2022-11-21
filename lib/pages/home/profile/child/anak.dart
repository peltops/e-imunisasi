import 'dart:ui';

import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/image_picker.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/anak_database.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
    DateTime _tanggalLahir = DateTime.parse(widget.tanggalLahir.toString());

    _namaCtrl = TextEditingController(text: widget.nama);
    _nikCtrl = TextEditingController(text: widget.nik);
    _tempatLahirCtrl = TextEditingController(text: widget.tempatLahir);
    _tanggalLahirCtrl = TextEditingController(
        text: DateFormat('dd-MM-yyyy').format(_tanggalLahir).toString());
    _jenisKelaminCtrl = TextEditingController(text: widget.jenisKelamin);
    _golDarahCtrl = TextEditingController(text: widget.golDarah);
    super.initState();
  }

  var pilihanJenisKelamin = ['Laki-laki', 'Perempuan', 'Lainnya'];
  var pilihanGolDarah = ['-', 'A', 'AB', 'B', 'O'];
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final kFirstDay = DateTime(DateTime.now().year - 5);
    final kLastDay = DateTime.now();
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
                height: MediaQuery.of(context).size.height / 5,
                child: Card(
                  elevation: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(child: _PhotoProfile(url: '')),
                      Text('Umur: ' +
                          Anak(tanggalLahir: widget.tanggalLahir).umurAnak)
                    ],
                  ),
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
                                        onChanged: (val) {
                                          _tempatLahirCtrl.text = val;
                                        },
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
                                            currentTime: widget.tanggalLahir,
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
                                padding: const EdgeInsets.all(5.0),
                                child: FormBuilderDropdown(
                                  onChanged: (val) {
                                    _jenisKelaminCtrl.text = val;
                                  },
                                  name: 'Jenis kelamin',
                                  decoration: InputDecoration(
                                    fillColor: Color(0xfff3f3f4),
                                    border: InputBorder.none,
                                    filled: true,
                                    labelText: 'Jenis Kelamin',
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  initialValue: _jenisKelaminCtrl.text,
                                  hint: Text(
                                    'Pilih jenis kelamin',
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context)
                                  ]),
                                  items: pilihanJenisKelamin
                                      .map((val) => DropdownMenuItem(
                                            value: val,
                                            child: Text('$val'),
                                          ))
                                      .toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: FormBuilderDropdown(
                                  onChanged: (val) {
                                    _golDarahCtrl.text = val;
                                  },
                                  name: 'Golongan Darah',
                                  decoration: InputDecoration(
                                    fillColor: Color(0xfff3f3f4),
                                    border: InputBorder.none,
                                    filled: true,
                                    labelText: 'Golongan Darah',
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  initialValue: _golDarahCtrl.text,
                                  hint: Text('Pilih golongan darah'),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context)
                                  ]),
                                  items: pilihanGolDarah
                                      .map((val) => DropdownMenuItem(
                                            value: val,
                                            child: Text('$val'),
                                          ))
                                      .toList(),
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
                                          setState(() {
                                            loading = true;
                                          });
                                          DateTime tempDate = new DateFormat(
                                                  "dd-MM-yyyy")
                                              .parse(_tanggalLahirCtrl.text);
                                          dismissKeyboard(context);
                                          try {
                                            AnakService()
                                                .setData(
                                                    Anak(
                                                        nik: _nikCtrl.text,
                                                        tempatLahir:
                                                            _tempatLahirCtrl
                                                                .text,
                                                        jenisKelamin:
                                                            _jenisKelaminCtrl
                                                                .text,
                                                        golDarah:
                                                            _golDarahCtrl.text,
                                                        nama: _namaCtrl.text,
                                                        tanggalLahir: tempDate),
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

class _PhotoProfile extends StatelessWidget {
  final String url;
  const _PhotoProfile({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          url == '' || url.isEmpty
              ? CircleAvatar(
                  radius: 30.0,
                  foregroundColor: Colors.white,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).accentColor,
                          radius: 15,
                          child: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(
                                Icons.photo_camera,
                                size: 15.0,
                              ),
                              onPressed: () async {
                                ModalPickerImage().showPicker(context);
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              : CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                      'https://i.pinimg.com/originals/d2/4d/db/d24ddb8271b8ea9b4bbf4b67df8cbc01.gif',
                      scale: 0.1),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(url, scale: 0.1),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 15,
                          child: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(
                                Icons.photo_camera,
                                size: 15.0,
                              ),
                              onPressed: () async {
                                ModalPickerImage().showPicker(context);
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
