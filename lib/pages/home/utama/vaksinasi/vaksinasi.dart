import 'package:eimunisasi/pages/home/utama/vaksinasi/daftar_vaksinasi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VaksinasiPage extends StatefulWidget {
  @override
  _VaksinasiPageState createState() => _VaksinasiPageState();
}

class _VaksinasiPageState extends State<VaksinasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            "Vaksinasi",
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: SvgPicture.asset(
                            'assets/images/undraw_medical_care_movn.svg',
                            semanticsLabel: 'A red up arrow'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                          child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DaftarVaksinasiPage()));
                        },
                        leading: Icon(
                          Icons.medical_services_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        title: Text('Vaksinasi'),
                      )),
                    ],
                  ),
                ),
              )),
        ));
  }
}
