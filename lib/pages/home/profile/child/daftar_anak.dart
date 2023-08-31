
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/models/list_imunisasi.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/anak_database.dart';
import 'package:eimunisasi/services/calendar_database.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as LibPicker;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DaftarAnakPage extends StatefulWidget {
  final indexAnak;
  const DaftarAnakPage({
    Key? key,
    required this.indexAnak,
  }) : super(key: key);

  @override
  _DaftarAnakPageState createState() => _DaftarAnakPageState();
}

class _DaftarAnakPageState extends State<DaftarAnakPage> {
  TextEditingController? _namaCtrl,
      _nikCtrl,
      _tempatLahirCtrl,
      _tanggalLahirCtrl,
      _jenisKelaminCtrl,
      _golDarahCtrl;

  final _formKey = GlobalKey<FormState>();
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

  var pilihanJenisKelamin = ['Laki-laki', 'Perempuan', 'Lainnya'];
  var pilihanGolDarah = ['-', 'A', 'AB', 'B', 'O'];
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
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
              Expanded(
                  child: Container(
                      width: double.infinity,
                      child: Card(
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: TextFormCustom(
                                    label: 'Nama Lengkap',
                                    onChanged: (val) {
                                      _namaCtrl!.text = val;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: TextFormCustom(
                                    keyboardType: TextInputType.number,
                                    label: 'NIK',
                                    onChanged: (val) {
                                      _nikCtrl!.text = val;
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
                                            _tempatLahirCtrl!.text = val;
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
                                              LibPicker.DatePicker.showDatePicker(context,
                                                  theme: LibPicker.DatePickerTheme(
                                                    doneStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                    cancelStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Nunito',
                                                      color: Colors.black,
                                                    ),
                                                    itemStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                  showTitleActions: true,
                                                  minTime: kFirstDay,
                                                  maxTime: kLastDay,
                                                  onChanged: (val) {
                                            String formattedDate =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(val);
                                            setState(() {
                                              _tanggalLahirCtrl!.text =
                                                  formattedDate.toString();
                                            });
                                          }, onConfirm: (val) {
                                            String formattedDate =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(val);
                                            setState(() {
                                              _tanggalLahirCtrl!.text =
                                                  formattedDate.toString();
                                            });
                                          },
                                                  currentTime: DateTime.now(),
                                                  locale: LibPicker.LocaleType.id),
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
                                    onChanged: (dynamic val) {
                                      _jenisKelaminCtrl!.text = val;
                                    },
                                    name: 'Jenis kelamin',
                                    decoration: InputDecoration(
                                      fillColor: Color(0xfff3f3f4),
                                      border: InputBorder.none,
                                      filled: true,
                                      labelText: 'Jenis Kelamin',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      hintText: 'Pilih jenis kelamin',
                                    ),
                                    validator: FormBuilderValidators.compose(
                                        [FormBuilderValidators.required()]),
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
                                    onChanged: (dynamic val) {
                                      _golDarahCtrl!.text = val;
                                    },
                                    name: 'Golongan Darah',
                                    decoration: InputDecoration(
                                      fillColor: Color(0xfff3f3f4),
                                      border: InputBorder.none,
                                      filled: true,
                                      labelText: 'Golongan Darah',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      hintText: 'Pilih golongan darah',
                                    ),
                                    validator: FormBuilderValidators.compose(
                                        [FormBuilderValidators.required()]),
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
                                  child: ButtonCustom(
                                    child: !loading
                                        ? Text(
                                            AppConstant.SAVE,
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
                                            dismissKeyboard(context);
                                            DateTime tempDate = new DateFormat(
                                                    "dd-MM-yyyy")
                                                .parse(_tanggalLahirCtrl!.text);
                                            setState(() {
                                              loading = true;
                                            });
                                            try {
                                              AnakService().setData(
                                                Anak(
                                                  nik: _nikCtrl!.text,
                                                  tempatLahir:
                                                      _tempatLahirCtrl!.text,
                                                  jenisKelamin:
                                                      _jenisKelaminCtrl!.text,
                                                  golDarah: _golDarahCtrl!.text,
                                                  nama: _namaCtrl!.text,
                                                  tanggalLahir: tempDate,
                                                ),
                                              );
                                              JadwalImunisasi()
                                                  .jadwalImunisai(user.uid,
                                                      tempDate, _namaCtrl!.text)
                                                  .forEach((e) =>
                                                      FirestoreDatabase(
                                                              uid: user.uid)
                                                          .setEvent(e));

                                              Navigator.pop(context);
                                            } catch (e) {
                                              snackbarCustom(
                                                      'Terjadi kesalahan: ' +
                                                          e.toString())
                                                  .show(context);
                                            } finally {
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          }
                                        : null,
                                  ),
                                )
                              ],
                            ),
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
