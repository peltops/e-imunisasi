import 'dart:io';

import 'package:e_imunisasi/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'widget/textdecoration.dart';
import 'package:e_imunisasi/services/database.dart';

class PersonalPage extends StatefulWidget {
  final Function toggleView;
  final String typeUser;
  PersonalPage({this.typeUser, this.toggleView});

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        tglLahir = picked.toString().split(' ')[0];
      });
  }

  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Email and Pass state
  String avatarPath;
  String nama;
  String nik;
  String tglLahir;
  String namaAyah;
  String pekerjaanAyah;
  String namaIbu;
  String pekerjaanIbu;
  String unitKerja;
  String alamat;
  String noTelp;
  String error = "";
  bool _edit = false;
  bool loading = false;

  //Controller

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // final typeUser = Provider.of<TypeUser>(context);

    Future<File> getImage() async {
      // ignore: deprecated_member_use
      return await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          "Personal Data",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _edit = !_edit;
              });
            },
          )
        ],
      ),
      body: StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid, email: user.email)
              .userData(widget.typeUser),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;

              return SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 30.0),
                      child: KeyboardAvoider(
                          child: Form(
                        key: _formKey,
                        child: Column(children: [
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                          userData.avatarURL == null
                              ? CircleAvatar(
                                  foregroundColor: Colors.white,
                                  radius: 50.0,
                                  child: Text(
                                    userData.nama.substring(0, 1),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage:
                                      NetworkImage(userData.avatarURL),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      radius: 15,
                                      child: IconButton(
                                          alignment: Alignment.center,
                                          icon: Icon(
                                            Icons.edit,
                                            size: 15.0,
                                          ),
                                          onPressed: () async {
                                            File file = await getImage();
                                            if (file != null) {
                                              avatarPath = await DatabaseService
                                                  .uploadImage(file);
                                              await DatabaseService(
                                                      uid: user.uid)
                                                  .uploadAvatarAnak(avatarPath,
                                                      widget.typeUser);
                                            }
                                            return null;
                                          }),
                                    ),
                                  ),
                                ),
                          Container(
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                              initialValue: userData.nama,
                              enabled: _edit,
                              decoration: !_edit
                                  ? InputDecoration(border: InputBorder.none)
                                  : null,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Masukkan Nama Anda';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                nama = val;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  child: TextFormField(
                                    controller: TextEditingController(
                                        text: tglLahir == null
                                            ? userData.tgllahir
                                            : tglLahir),
                                    enabled: _edit,
                                    readOnly: true,
                                    decoration: textDecoration.copyWith(
                                      hintText: "klik ubah",
                                      labelText: 'Tanggal Lahir',
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.date_range),
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                      ),
                                    ),
                                    validator: (val) => val.length == 0
                                        ? 'Masukan Tanggal Lahir'
                                        : null,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      initialValue: userData.nik,
                                      enabled: _edit,
                                      decoration: textDecoration.copyWith(
                                        hintText: '342537864313341',
                                        labelText: 'NIK',
                                      ),
                                      validator: (val) =>
                                          val.isEmpty ? 'Masukkan NIK' : null,
                                      onChanged: (val) {
                                        nik = val;
                                      }),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          widget.typeUser == "anakCollection"
                              ? Row(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.only(right: 5.0),
                                        child: TextFormField(
                                          initialValue: userData.namaAyah,
                                          enabled: _edit,
                                          decoration: textDecoration.copyWith(
                                            labelText: 'Nama Ayah',
                                          ),
                                          validator: (val) => val.length == 0
                                              ? 'Masukan Nama Ayah'
                                              : null,
                                          onChanged: (val) {
                                            namaAyah = val;
                                          },
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: TextFormField(
                                          initialValue: userData.pekerjaanAyah,
                                          enabled: _edit,
                                          decoration: textDecoration.copyWith(
                                            labelText: 'Pekerjaan Ayah',
                                          ),
                                          validator: (val) => val.length == 0
                                              ? 'Masukan Pekerjaan Ayah'
                                              : null,
                                          onChanged: (val) {
                                            pekerjaanAyah = val;
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Container(
                                  child: TextFormField(
                                    initialValue: userData.unitKerja,
                                    enabled: _edit,
                                    decoration: textDecoration.copyWith(
                                      labelText: 'Unit Kerja',
                                    ),
                                    validator: (val) => val.length == 0
                                        ? 'Masukan Unit Kerja'
                                        : null,
                                    onChanged: (val) {
                                      unitKerja = val;
                                    },
                                  ),
                                ),
                          SizedBox(
                            height: 20.0,
                          ),
                          widget.typeUser == "anakCollection"
                              ? Row(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.only(right: 5.0),
                                        child: TextFormField(
                                          initialValue: userData.namaIbu,
                                          enabled: _edit,
                                          decoration: textDecoration.copyWith(
                                            labelText: 'Nama Ibu',
                                          ),
                                          validator: (val) => val.length == 0
                                              ? 'Masukan Nama Ibu'
                                              : null,
                                          onChanged: (val) {
                                            namaIbu = val;
                                          },
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: TextFormField(
                                          initialValue: userData.pekerjaanIbu,
                                          enabled: _edit,
                                          decoration: textDecoration.copyWith(
                                            labelText: 'Pekerjaan Ibu',
                                          ),
                                          validator: (val) => val.length == 0
                                              ? 'Masukan Pekerjaan Ibu'
                                              : null,
                                          onChanged: (val) {
                                            pekerjaanIbu = val;
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox(),
                          widget.typeUser == "anakCollection"
                              ? SizedBox(
                                  height: 20.0,
                                )
                              : SizedBox(),
                          Container(
                            child: TextFormField(
                              initialValue: userData.alamat,
                              enabled: _edit,
                              decoration: textDecoration.copyWith(
                                labelText: 'Alamat',
                              ),
                              validator: (val) => val.length == 0
                                  ? 'Masukan Alamat Lengkap'
                                  : null,
                              onChanged: (val) {
                                alamat = val;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: userData.noTlp,
                              enabled: _edit,
                              decoration: textDecoration.copyWith(
                                labelText: 'No Telp',
                              ),
                              validator: (val) =>
                                  val.length < 10 ? 'Masukan No Telpon' : null,
                              onChanged: (val) {
                                noTelp = val;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: Offset(4, 2),
                                      blurRadius: 5,
                                      spreadRadius: 2)
                                ],
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xfffbb448),
                                      Color(0xfff7892b)
                                    ])),
                            child: _edit
                                ? FlatButton(
                                    onPressed: !loading
                                        ? () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                loading = true;
                                                _edit = false;
                                              });
                                              widget.typeUser ==
                                                      'anakCollection'
                                                  ? await DatabaseService(
                                                          uid: user.uid)
                                                      .updateUserDataAnak(
                                                          userData.email,
                                                          nama ?? userData.nama,
                                                          nik ?? userData.nik,
                                                          tglLahir ??
                                                              userData.tgllahir,
                                                          namaAyah ??
                                                              userData.namaAyah,
                                                          pekerjaanAyah ??
                                                              userData
                                                                  .pekerjaanAyah,
                                                          namaIbu ??
                                                              userData.namaIbu,
                                                          pekerjaanIbu ??
                                                              userData
                                                                  .pekerjaanIbu,
                                                          alamat ??
                                                              userData.alamat,
                                                          noTelp ??
                                                              userData.noTlp)
                                                  : DatabaseService(
                                                          uid: user.uid)
                                                      .updateUserDataMedis(
                                                          userData.email,
                                                          nama ?? userData.nama,
                                                          nik ?? userData.nik,
                                                          tglLahir ??
                                                              userData.tgllahir,
                                                          alamat ??
                                                              userData.alamat,
                                                          unitKerja ??
                                                              userData
                                                                  .unitKerja,
                                                          noTelp ??
                                                              userData.noTlp);

                                              Navigator.pop(context);
                                            }
                                          }
                                        : null,
                                    child: !loading
                                        ? Text(
                                            "Edit",
                                            style:
                                                TextStyle(color: Colors.white),
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
                                  )
                                : null,
                          ),
                        ]),
                      ))));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
