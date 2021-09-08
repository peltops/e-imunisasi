import 'package:eimunisasi/models/user.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/image_picker.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/user_database.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class OrangtuaPage extends StatefulWidget {
  const OrangtuaPage({Key key}) : super(key: key);

  @override
  _OrangtuaPageState createState() => _OrangtuaPageState();
}

class _OrangtuaPageState extends State<OrangtuaPage> {
  TextEditingController _namaAyahCtrl,
      _namaIbuCtrl,
      _pekerjaanAyahCtrl,
      _pekerjaanIbuCtrl,
      _golDarahAyahCtrl,
      _golDarahIbuCtrl,
      _nomorAyahCtrl,
      _nomorIbuCtrl,
      _alamatCtrl;
  @override
  void initState() {
    _namaAyahCtrl = TextEditingController();
    _namaIbuCtrl = TextEditingController();
    _pekerjaanAyahCtrl = TextEditingController();
    _pekerjaanIbuCtrl = TextEditingController();
    _golDarahAyahCtrl = TextEditingController();
    _golDarahIbuCtrl = TextEditingController();
    _nomorAyahCtrl = TextEditingController();
    _nomorIbuCtrl = TextEditingController();
    _alamatCtrl = TextEditingController();
    super.initState();
  }

  var pilihanGolDarah = ['-', 'A', 'AB', 'B', 'O'];
  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseAuth.instance.currentUser;
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
      body: StreamBuilder<Users>(
          stream: UserService().userStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Users user = snapshot.data;
              _namaAyahCtrl.text = user.dadName;
              _namaIbuCtrl.text = user.momName;
              _pekerjaanAyahCtrl.text = user.pekerjaanAyah;
              _pekerjaanIbuCtrl.text = user.pekerjaanIbu;
              _golDarahAyahCtrl.text = user.golDarahAyah;
              _golDarahIbuCtrl.text = user.golDarahIbu;
              _nomorAyahCtrl.text = user.nomorhpAyah;
              _nomorIbuCtrl.text = user.nomorhpIbu;
              _alamatCtrl.text = user.alamat;

              return Container(
                color: Colors.pink[100],
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        // height: MediaQuery.of(context).size.height / 6,
                        child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                user.avatarURL == ''
                                    ? CircleAvatar(
                                        foregroundColor: Colors.white,
                                        radius: 50.0,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                user.momName.substring(0, 1),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 50),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: CircleAvatar(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .accentColor,
                                                radius: 15,
                                                child: IconButton(
                                                    alignment: Alignment.center,
                                                    icon: Icon(
                                                      Icons.photo_camera,
                                                      size: 15.0,
                                                    ),
                                                    onPressed: () async {
                                                      ModalPickerImage()
                                                          .showPicker(context);
                                                    }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 50.0,
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
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: NetworkImage(
                                                    user.avatarURL,
                                                    scale: 0.1),
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
                                                      ModalPickerImage()
                                                          .showPicker(context);
                                                    }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_currentUser.email),
                                    Text(_currentUser.emailVerified
                                        ? ' (Terverifikasi)'
                                        : ' (Belum Verifikasi)'),
                                  ],
                                ),
                              ],
                            ),
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
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: TextFormCustom(
                                                initialValue: user.dadName,
                                                label: 'Nama Ayah',
                                                validator: (val) => val.length <
                                                        8
                                                    ? 'Masukan Password min 8'
                                                    : null,
                                                onChanged: (val) {
                                                  _namaAyahCtrl.text = val;
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: TextFormCustom(
                                                initialValue: user.momName,
                                                label: 'Nama Ibu',
                                                onChanged: (val) {
                                                  _namaIbuCtrl.text = val;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: TextFormCustom(
                                                initialValue:
                                                    user.pekerjaanAyah,
                                                label: 'Pekerjaan Ayah',
                                                onChanged: (val) {
                                                  _pekerjaanAyahCtrl.text = val;
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: TextFormCustom(
                                                initialValue: user.pekerjaanIbu,
                                                label: 'Pekerjaan Ibu',
                                                onChanged: (val) {
                                                  _pekerjaanIbuCtrl.text = val;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: FormBuilderDropdown(
                                                onChanged: (val) {
                                                  _golDarahAyahCtrl.text = val;
                                                },
                                                name: 'Golongan Darah',
                                                decoration: InputDecoration(
                                                  fillColor: Color(0xfff3f3f4),
                                                  border: InputBorder.none,
                                                  filled: true,
                                                  labelText: 'Golongan Darah',
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                initialValue: user.golDarahAyah,
                                                hint: Text(
                                                    'Pilih golongan darah'),
                                                validator: FormBuilderValidators
                                                    .compose([
                                                  FormBuilderValidators
                                                      .required(context)
                                                ]),
                                                items: pilihanGolDarah
                                                    .map((val) =>
                                                        DropdownMenuItem(
                                                          value: val,
                                                          child: Text('$val'),
                                                        ))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: FormBuilderDropdown(
                                                onChanged: (val) {
                                                  _golDarahIbuCtrl.text = val;
                                                },
                                                name: 'Golongan Darah',
                                                decoration: InputDecoration(
                                                  fillColor: Color(0xfff3f3f4),
                                                  border: InputBorder.none,
                                                  filled: true,
                                                  labelText: 'Golongan Darah',
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                initialValue: user.golDarahIbu,
                                                hint: Text(
                                                    'Pilih golongan darah'),
                                                validator: FormBuilderValidators
                                                    .compose([
                                                  FormBuilderValidators
                                                      .required(context)
                                                ]),
                                                items: pilihanGolDarah
                                                    .map((val) =>
                                                        DropdownMenuItem(
                                                          value: val,
                                                          child: Text('$val'),
                                                        ))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: TextFormCustom(
                                                initialValue: user.nomorhpAyah,
                                                label: 'No.handphone Ayah',
                                                onChanged: (val) {
                                                  _nomorAyahCtrl.text = val;
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: TextFormCustom(
                                                initialValue: user.nomorhpIbu,
                                                label: 'No.handphone Ibu',
                                                onChanged: (val) {
                                                  _nomorIbuCtrl.text = val;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: TextFormCustom(
                                          initialValue: user.alamat,
                                          label: 'Alamat',
                                          onChanged: (val) {
                                            _alamatCtrl.text = val;
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
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                ),
                                          onPressed: !loading
                                              ? () async {
                                                  dismissKeyboard(context);
                                                  loading = true;
                                                  await UserService()
                                                      .updateUser(Users(
                                                          alamat:
                                                              _alamatCtrl.text,
                                                          dadName: _namaAyahCtrl
                                                              .text,
                                                          momName:
                                                              _namaIbuCtrl.text,
                                                          nomorhpAyah:
                                                              _nomorAyahCtrl
                                                                  .text,
                                                          golDarahAyah:
                                                              _golDarahAyahCtrl
                                                                  .text,
                                                          pekerjaanAyah:
                                                              _pekerjaanAyahCtrl
                                                                  .text,
                                                          nomorhpIbu:
                                                              _nomorIbuCtrl
                                                                  .text,
                                                          golDarahIbu:
                                                              _golDarahIbuCtrl
                                                                  .text,
                                                          pekerjaanIbu:
                                                              _pekerjaanIbuCtrl
                                                                  .text,
                                                          avatarURL:
                                                              user.avatarURL))
                                                      .then((value) {
                                                        snackbarCustom(
                                                                'Data berhasil diperbarui')
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
                                                  setState(() {
                                                    loading = false;
                                                  });
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
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Text('Tidak ada data'),
            );
          }),
    );
  }
}
