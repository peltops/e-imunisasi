import 'package:e_imunisasi/models/user.dart';
import 'package:e_imunisasi/pages/bukusehatpage/add_event.dart';
import 'package:e_imunisasi/pages/bukusehatpage/wrapperAnak.dart';
import 'package:e_imunisasi/pages/bukusehatpage/wrapperMedis.dart';
import 'package:e_imunisasi/pages/widget/cardName.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BukuSehatPage extends StatefulWidget {
  @override
  _BukuSehatPageState createState() => _BukuSehatPageState();
}

class _BukuSehatPageState extends State<BukuSehatPage> {
  @override
  Widget build(BuildContext context) {
    final typeUser = Provider.of<TypeUser>(context).typeUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Buku Sehat",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          CardName(),
          typeUser == 'anakCollection'
              ? WrapperAnakBukuSehat()
              : WrapperMedisBukuSehat(),
        ],
      )),
      floatingActionButton: typeUser == 'medisCollection'
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEventRiwayatImunisasi(
                            typeUser: typeUser,
                          ))),
            )
          : null,
    );
  }
}
