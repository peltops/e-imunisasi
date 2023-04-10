import 'package:cached_network_image/cached_network_image.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/image_picker.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/user_database.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class OrangtuaPage extends StatefulWidget {
  const OrangtuaPage({Key? key}) : super(key: key);

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
      _emailCtrl,
      _alamatCtrl,
      _tempatLahirCtrl,
      _tanggalLahirCtrl,
      _nomorKkCtrl,
      _nomorKtpCtrl;

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
    _emailCtrl = TextEditingController();
    _alamatCtrl = TextEditingController();
    _tempatLahirCtrl = TextEditingController();
    _tanggalLahirCtrl = TextEditingController();
    _nomorKkCtrl = TextEditingController();
    _nomorKtpCtrl = TextEditingController();
    super.initState();
  }

  var pilihanGolDarah = ['-', 'A', 'AB', 'B', 'O'];
  var pilihanPekerjaan = ['IRT', 'ASN/Karyawan', 'Wirausaha'];
  @override
  Widget build(BuildContext context) {
    final kFirstDay = DateTime(DateTime.now().year - 5);
    final kLastDay = DateTime.now();
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
              Users user = snapshot.data!;
              _namaAyahCtrl.text = user.dadName ?? '';
              _namaIbuCtrl.text = user.momName ?? '';
              _pekerjaanAyahCtrl.text = user.pekerjaanAyah ?? '';
              _pekerjaanIbuCtrl.text = user.pekerjaanIbu ?? '';
              _golDarahAyahCtrl.text = user.golDarahAyah ?? '';
              _golDarahIbuCtrl.text = user.golDarahIbu ?? '';
              _nomorAyahCtrl.text = user.nomorhpAyah ?? '';
              _nomorIbuCtrl.text = user.nomorhpIbu ?? '';
              _alamatCtrl.text = user.alamat ?? '';
              _emailCtrl.text = _currentUser!.email ?? '';
              _tempatLahirCtrl.text = user.tempatLahir ?? '';
              // _tanggalLahirCtrl.text = user.tanggalLahir != null
              //     ? DateFormat('dd-MM-yyyy').format(user.tanggalLahir)
              //     : 'Pilih Tanggal Lahir';
              _nomorKkCtrl.text = user.noKK ?? '';
              _nomorKtpCtrl.text = user.noKTP ?? '';
              if (!pilihanPekerjaan.contains(user.pekerjaanIbu)) {
                pilihanPekerjaan.add(user.pekerjaanIbu);
              }
              final tanggalLahir = user.tanggalLahir != null
                  ? DateFormat('dd-MM-yyyy').format(user.tanggalLahir!)
                  : 'Pilih Tanggal Lahir';
              return Container(
                color: Colors.pink[100],
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: Card(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _PhotoProfile(url: user.avatarURL),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Profil Orangtua',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    TextFormCustom(
                                      initialValue: user.momName,
                                      label:
                                          'Nama Lengkap (Sesuai Akte Lahir/KTP)',
                                      onChanged: (val) {
                                        _namaIbuCtrl.text = val;
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormCustom(
                                            initialValue: user.tempatLahir,
                                            label: 'Tempat Lahir',
                                            onChanged: (val) {
                                              _tempatLahirCtrl.text = val;
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormCustom(
                                            onTap: () =>
                                                DatePicker.showDatePicker(
                                              context,
                                              theme: DatePickerTheme(
                                                doneStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
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
                                              onChanged: (val) {
                                                String formattedDate =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(val);
                                                setState(() {
                                                  _tanggalLahirCtrl.text =
                                                      formattedDate.toString();
                                                });
                                              },
                                              onConfirm: (val) {
                                                String formattedDate =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(val);
                                                setState(() {
                                                  _tanggalLahirCtrl.text =
                                                      formattedDate.toString();
                                                });
                                              },
                                              currentTime: user.tanggalLahir ??
                                                  DateTime.now(),
                                              locale: LocaleType.id,
                                            ),
                                            readOnly: true,
                                            label: 'Tanggal Lahir',
                                            hintText: _tanggalLahirCtrl
                                                    .text.isNotEmpty
                                                ? _tanggalLahirCtrl.text
                                                : tanggalLahir,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextFormCustom(
                                      keyboardType: TextInputType.number,
                                      initialValue: user.noKTP,
                                      label: 'No NIK',
                                      onChanged: (val) {
                                        _nomorKtpCtrl.text = val;
                                      },
                                    ),
                                    TextFormCustom(
                                      keyboardType: TextInputType.number,
                                      initialValue: user.noKK,
                                      label: 'No KK',
                                      onChanged: (val) {
                                        _nomorKkCtrl.text = val;
                                      },
                                    ),
                                    FormBuilderDropdown(
                                      onChanged: (dynamic val) {
                                        _pekerjaanIbuCtrl.text = val;
                                      },
                                      name: 'Pekerjaan',
                                      decoration: InputDecoration(
                                        fillColor: Color(0xfff3f3f4),
                                        border: InputBorder.none,
                                        filled: true,
                                        labelText: 'Pekerjaan',
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      initialValue: user.pekerjaanIbu,
                                      hint: Text('Pilih Pekerjaan'),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(context)
                                      ]),
                                      items: pilihanPekerjaan
                                          .map((val) => DropdownMenuItem(
                                                value: val,
                                                child: Text('$val'),
                                              ))
                                          .toList(),
                                    ),
                                    SizedBox(height: 5),
                                    FormBuilderDropdown(
                                      onChanged: (dynamic val) {
                                        _golDarahIbuCtrl.text = val;
                                      },
                                      name: 'Golongan Darah',
                                      decoration: InputDecoration(
                                        fillColor: Color(0xfff3f3f4),
                                        border: InputBorder.none,
                                        filled: true,
                                        labelText: 'Golongan Darah',
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                      initialValue: user.golDarahIbu,
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
                                    const SizedBox(height: 10),
                                    Text(
                                      'Informasi Akun',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    if (_currentUser.email != null)
                                      TextFormCustom(
                                        readOnly: true,
                                        initialValue: _currentUser.email,
                                        label: 'Email',
                                        onChanged: (val) {
                                          _emailCtrl.text = val;
                                        },
                                      ),
                                    if (_currentUser.phoneNumber != null)
                                      TextFormCustom(
                                        readOnly: true,
                                        initialValue: _currentUser.phoneNumber,
                                        label: 'No.handphone Ibu',
                                        onChanged: (val) {
                                          _nomorIbuCtrl.text = val;
                                        },
                                      ),
                                    SizedBox(height: 10),
                                    ButtonCustom(
                                      child: !loading
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
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            ),
                                      onPressed: !loading
                                          ? () async {
                                              DateTime? tempDate =
                                                  _tanggalLahirCtrl
                                                          .text.isNotEmpty
                                                      ? new DateFormat(
                                                              "dd-MM-yyyy")
                                                          .parse(
                                                              _tanggalLahirCtrl
                                                                  .text)
                                                      : user.tanggalLahir;
                                              dismissKeyboard(context);
                                              loading = true;
                                              await UserService()
                                                  .updateUser(
                                                    Users(
                                                      alamat: _alamatCtrl.text,
                                                      dadName:
                                                          _namaAyahCtrl.text,
                                                      momName:
                                                          _namaIbuCtrl.text,
                                                      nomorhpAyah:
                                                          _nomorAyahCtrl.text,
                                                      golDarahAyah:
                                                          _golDarahAyahCtrl
                                                              .text,
                                                      pekerjaanAyah:
                                                          _pekerjaanAyahCtrl
                                                              .text,
                                                      nomorhpIbu:
                                                          _nomorIbuCtrl.text,
                                                      golDarahIbu:
                                                          _golDarahIbuCtrl.text,
                                                      pekerjaanIbu:
                                                          _pekerjaanIbuCtrl
                                                              .text,
                                                      avatarURL: user.avatarURL,
                                                      tanggalLahir: tempDate,
                                                      tempatLahir:
                                                          _tempatLahirCtrl.text,
                                                      noKK: _nomorKkCtrl.text,
                                                      noKTP: _nomorKtpCtrl.text,
                                                    ),
                                                  )
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
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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

class _PhotoProfile extends StatelessWidget {
  final String? url;
  const _PhotoProfile({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseAuth.instance.currentUser!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          url == null || url!.isEmpty
              ? CircleAvatar(
                  foregroundColor: Colors.white,
                  radius: 50.0,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          radius: 15,
                          child: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(
                                Icons.photo_camera,
                                size: 15.0,
                              ),
                              onPressed: () async {
                                ModalPickerImage().showPicker(context, (val) {
                                  UserService().updateUserAvatar(val);
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              : CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: CachedNetworkImageProvider(
                      'https://i.pinimg.com/originals/d2/4d/db/d24ddb8271b8ea9b4bbf4b67df8cbc01.gif',
                      scale: 0.1),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              CachedNetworkImageProvider(url!, scale: 0.1),
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
                                ModalPickerImage().showPicker(context, (val) {
                                  UserService().updateUserAvatar(val);
                                });
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
              _currentUser.email != null
                  ? _currentUser.emailVerified
                      ? Text(' (Terverifikasi)')
                      : GestureDetector(
                          onTap: () async {
                            try {
                              await _currentUser.sendEmailVerification();
                              snackbarCustom(
                                      "Berhasil, cek email ${_currentUser.email}")
                                  .show(context);
                            } on FirebaseException catch (e) {
                              snackbarCustom(e.message).show(context);
                            } catch (e) {
                              snackbarCustom("Terjadi kesalahan: \n $e")
                                  .show(context);
                            }
                          },
                          child: Text(
                            'Belum Terverifikasi (Verifikasi sekarang)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
