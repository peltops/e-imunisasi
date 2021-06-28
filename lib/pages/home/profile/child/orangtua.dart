import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:flutter/material.dart';

class OrangtuaPage extends StatefulWidget {
  const OrangtuaPage({Key key}) : super(key: key);

  @override
  _OrangtuaPageState createState() => _OrangtuaPageState();
}

class _OrangtuaPageState extends State<OrangtuaPage> {
  @override
  Widget build(BuildContext context) {
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
                  child: Center(child: Text("Nama")),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: TextFormCustom(
                                        label: 'Nama Ayah',
                                        validator: (val) => val.length < 8
                                            ? 'Masukan Password min 8'
                                            : null,
                                        onChanged: (val) {
                                          setState(() {
                                            // password = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: TextFormCustom(
                                        label: 'Nama Ibu',
                                        onChanged: (val) {
                                          setState(() {
                                            // password = val;
                                          });
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: TextFormCustom(
                                        label: 'Pekerjaan Ayah',
                                        onChanged: (val) {
                                          setState(() {
                                            // password = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: TextFormCustom(
                                        label: 'Pekerjaan Ibu',
                                        onChanged: (val) {
                                          setState(() {
                                            // password = val;
                                          });
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: TextFormCustom(
                                        label: 'Gol darah Ayah',
                                        onChanged: (val) {
                                          setState(() {
                                            // password = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: TextFormCustom(
                                        label: 'Gol darah Ibu',
                                        onChanged: (val) {
                                          setState(() {
                                            // password = val;
                                          });
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: TextFormCustom(
                                        label: 'No.handphone Ayah',
                                        onChanged: (val) {
                                          setState(() {
                                            // password = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: TextFormCustom(
                                        label: 'No.handphone Ibu',
                                        onChanged: (val) {
                                          setState(() {
                                            // password = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextFormCustom(
                                  label: 'Alamat',
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
