import 'dart:ui';

import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DaftarAnakPage extends StatefulWidget {
  const DaftarAnakPage({
    Key key,
  }) : super(key: key);

  @override
  _DaftarAnakPageState createState() => _DaftarAnakPageState();
}

class _DaftarAnakPageState extends State<DaftarAnakPage> {
  TextEditingController _namaCtrl,
      _nikCtrl,
      _tempatLahirCtrl,
      _tanggalLahirCtrl,
      _jenisKelaminCtrl,
      _golDarahCtrl;
  @override
  void initState() {
    _tanggalLahirCtrl = TextEditingController(text: '');
    _namaCtrl = TextEditingController(text: '');
    _nikCtrl = TextEditingController(text: '');
    _tempatLahirCtrl = TextEditingController(text: '');
    _jenisKelaminCtrl = TextEditingController(text: '');
    _golDarahCtrl = TextEditingController(text: '');
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
                                        onTap: () =>
                                            DatePicker.showDatePicker(context,
                                                theme: DatePickerTheme(
                                                  doneStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                ),
                                                showTitleActions: true,
                                                minTime: kFirstDay,
                                                maxTime: kLastDay,
                                                onChanged: (val) {
                                          String formattedDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(val);
                                          setState(() {
                                            _tanggalLahirCtrl.text =
                                                formattedDate.toString();
                                          });
                                        }, onConfirm: (val) {
                                          String formattedDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(val);
                                          setState(() {
                                            _tanggalLahirCtrl.text =
                                                formattedDate.toString();
                                          });
                                        },
                                                currentTime: DateTime.now(),
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
                                  label: 'Jenis Kelamin',
                                  onChanged: (val) {
                                    _jenisKelaminCtrl.text = val;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextFormCustom(
                                  label: 'Golongan Darah',
                                  onChanged: (val) {
                                    _golDarahCtrl.text = val;
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
                                          // if (_formKey.currentState.validate()) {
                                          //   dismissKeyboard(context);
                                          //   setState(() {
                                          //     loading = true;
                                          //   });
                                          //   try {
                                          //     await _auth.signIn(email, password);
                                          //     setState(() {
                                          //       loading = false;
                                          //     });
                                          //   } catch (e) {
                                          //     snackbarCustom(e.message.toString())
                                          //         .show(context);
                                          //   }
                                          // }
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
