import 'package:e_imunisasi/models/user.dart';
import 'package:e_imunisasi/pages/profilepage/widget/textdecoration.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  RegExp regex = new RegExp(r',');
  // TextEditingController _email;
  TextEditingController _beratBadan;
  TextEditingController _tinggiBadan;
  TextEditingController _lingkarBadan;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    // _email = TextEditingController();
    _beratBadan = TextEditingController();
    _tinggiBadan = TextEditingController();
    _lingkarBadan = TextEditingController();
    _eventDate = DateTime.now();
    processing = false;
  }

  listSemuaData(List<GetAllUser> all) {
    var data = [];
    all.asMap().forEach((index, value) {
      data.add(value.nama);
    });
    return data;
  }

  String _emailpick;
  cariUserDetail(List<GetAllUser> all,
      {bool nama = false, bool tgllahir = false}) {
    var _userSelectedName;
    var _userSelectedtgllahir;
    var _userSelectedID;
    all.asMap().forEach((key, e) {
      if (e.email == _emailpick) {
        _userSelectedName = e.nama;
        _userSelectedtgllahir = e.tgllahir;
        _userSelectedID = e.documentID;
      }
    });
    if (tgllahir) {
      return _userSelectedtgllahir;
    } else if (nama) {
      return _userSelectedName;
    }
    return _userSelectedID;
  }

  cariDroplisttgllahir(List<GetAllUser> all) {
    final selectedUsers = all.where((u) => _emailpick.contains(u.nama));
    final tgl = selectedUsers.map((e) => e.tgllahir);
    return tgl.toString().substring(1, tgl.toString().length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<List<GetAllUser>>(
        stream: DatabaseService().allUserAnak,
        builder:
            (BuildContext context, AsyncSnapshot<List<GetAllUser>> snapshot) {
          if (snapshot.hasData) {
            List<GetAllUser> allUserAnak = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 0.0,
                title: Text(
                  "Tambah data perkembangan anak",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              key: _key,
              body: Form(
                key: _formKey,
                child: Container(
                  alignment: Alignment.center,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: DropdownButton(
                          hint: Text("Pilih nama peserta"),
                          value: _emailpick,
                          items: allUserAnak.map((value) {
                            return DropdownMenuItem(
                              child: Text(value.email),
                              value: value.email,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _emailpick = value;
                            });
                            print(cariUserDetail(allUserAnak));
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("Date (YYYY-MM-DD)"),
                        subtitle: Text(
                            "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                        onTap: () async {
                          DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: _eventDate,
                              firstDate: DateTime(_eventDate.year - 5),
                              lastDate: DateTime(_eventDate.year + 5));
                          if (picked != null) {
                            setState(() {
                              _eventDate = picked;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _beratBadan,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w600),
                          decoration: textDecoration.copyWith(
                            labelText: 'Berat Badan (Kg)',
                          ),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Masukkan berat badan anda';
                            } else if (val.length > 5) {
                              return 'Masukkan max 5 karakter';
                            } else if (regex.hasMatch(val)) {
                              return 'Gunakan . untuk membuat angka desimal';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _tinggiBadan,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w600),
                          decoration: textDecoration.copyWith(
                            labelText: 'Tinggi Badan (Cm)',
                          ),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Masukkan tinggi badan Anda';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _lingkarBadan,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w600),
                          decoration: textDecoration.copyWith(
                            labelText: 'Lingkar Badan (Cm)',
                          ),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Masukkan lingkar badan Anda';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Container(
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
                            child: FlatButton(
                              onPressed: !processing
                                  ? () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          processing = true;
                                        });
                                        final DataTumbuh data = DataTumbuh(
                                            idMedis: user.uid,
                                            idPeserta:
                                                cariUserDetail(allUserAnak),
                                            email: _emailpick,
                                            tgllahir: cariUserDetail(
                                                allUserAnak,
                                                tgllahir: true),
                                            nama: cariUserDetail(allUserAnak,
                                                nama: true),
                                            beratBadan: _beratBadan.text,
                                            tinggiBadan: _tinggiBadan.text,
                                            lingkarBadan: _lingkarBadan.text,
                                            takeDate: _eventDate);
                                        await DatabaseService(uid: user.uid)
                                            .addPerkembangan(data.toMap());

                                        Navigator.pop(context);
                                      }
                                    }
                                  : null,
                              child: !processing
                                  ? Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
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
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  @override
  void dispose() {
    _beratBadan.dispose();
    _tinggiBadan.dispose();
    _lingkarBadan.dispose();
    super.dispose();
  }
}
