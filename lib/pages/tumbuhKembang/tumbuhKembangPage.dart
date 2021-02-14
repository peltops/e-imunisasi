import 'package:e_imunisasi/models/user.dart';
import 'package:e_imunisasi/pages/tumbuhKembang/add_event.dart';
import 'package:e_imunisasi/pages/tumbuhKembang/wrapperAnak.dart';
import 'package:e_imunisasi/pages/tumbuhKembang/wrapperMedis.dart';
import 'package:flutter/material.dart';
import 'package:e_imunisasi/pages/widget/cardName.dart';
import 'package:provider/provider.dart';

class TumbuhKembang extends StatefulWidget {
  @override
  _TumbuhKembangState createState() => _TumbuhKembangState();
}

class _TumbuhKembangState extends State<TumbuhKembang> {
  @override
  Widget build(BuildContext context) {
    final typeUser = Provider.of<TypeUser>(context).typeUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Tumbuh Kembang",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          CardName(),
          typeUser == 'anakCollection'
              ? WrapperAnakTumbuhKembang()
              : WrapperMedisTumbuhKembang(),
        ]),
      ),
      floatingActionButton: typeUser == 'medisCollection'
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddEventPage())),
            )
          : null,
    );
  }
}
