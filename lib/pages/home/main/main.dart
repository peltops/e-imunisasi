import 'package:eimunisasi/pages/home/main/Kontak/kontak.dart';
import 'package:eimunisasi/pages/home/main/bukusehat/child/list_anak.dart';
import 'package:eimunisasi/pages/home/main/calendar/kalender.dart';
import 'package:eimunisasi/pages/home/main/vaksinasi/vaksinasi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Utama',
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
                height: MediaQuery.of(context).size.height / 4,
                child: Card(
                    elevation: 0,
                    child:
                        SvgPicture.asset('assets/images/undraw_baby_ja7a.svg')),
              ),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Card(
                    elevation: 0,
                    child: GridView.count(
                        padding: EdgeInsets.all(20),
                        crossAxisCount: 2,
                        children: [
                          TombolMenu(
                                  icon: Icons.calendar_today,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                KalenderPage()));
                                  },
                                  label: 'Kalender')
                              .tombolMenuCustom(),
                          TombolMenu(
                                  icon: Icons.medical_services_rounded,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VaksinasiPage()));
                                  },
                                  label: 'Vaksinasi')
                              .tombolMenuCustom(),
                          TombolMenu(
                                  icon: Icons.my_library_books_rounded,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ListAnak()));
                                  },
                                  label: 'Buku Sehat')
                              .tombolMenuCustom(),
                          TombolMenu(
                                  icon: Icons.contact_support_rounded,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                KontakPage()));
                                  },
                                  label: 'Kontak')
                              .tombolMenuCustom(),
                        ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class TombolMenu {
  Function onTap;
  IconData icon;
  String label;
  TombolMenu({this.icon, this.label, this.onTap});

  tombolMenuCustom() => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.pink[500],
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              )
            ],
          ),
        ),
      );
}
