import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/pages/home/utama/kontak/klinik/list_daftar_klinik.dart';
import 'package:eimunisasi/pages/home/utama/kontak/tenaga_kesehatan/daftar_nakes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class KontakPage extends StatefulWidget {
  @override
  _KontakPageState createState() => _KontakPageState();
}

class _KontakPageState extends State<KontakPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            AppConstant.CONTACT,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: SizedBox.expand(
          child: Container(
              color: Colors.pink[100],
              child: Card(
                margin: EdgeInsets.all(20),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                          height: 150,
                          child: SvgPicture.asset(
                              'assets/images/undraw_doctors_hwty.svg')),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                          child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DaftarNakes()));
                        },
                        leading: Icon(
                          Icons.medical_services_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        title: Text('Tenaga Kesehatan'),
                      )),
                      Card(
                          child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ListDaftarKlinik()));
                        },
                        leading: Icon(
                          Icons.local_hospital_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        title: Text('Klinik'),
                      )),
                    ],
                  ),
                ),
              )),
        ));
  }
}
