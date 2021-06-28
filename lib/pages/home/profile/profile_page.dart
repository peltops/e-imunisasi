import 'package:eimunisasi/pages/home/profile/child/list_anak.dart';
import 'package:eimunisasi/pages/home/profile/child/orangtua.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
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
                height: MediaQuery.of(context).size.height / 4,
                child: Card(
                    elevation: 0,
                    child: SvgPicture.asset(
                        'assets/images/undraw_online_cv_qy9w.svg')),
              ),
              Card(
                  child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListAnak()));
                },
                title: Text(
                  'Anak',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: Icon(Icons.keyboard_arrow_right_rounded),
              )),
              Card(
                  child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrangtuaPage()));
                },
                title: Text(
                  'Orangtua',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: Icon(Icons.keyboard_arrow_right_rounded),
              )),
              SizedBox(height: 20),
              Card(
                  child: ListTile(
                      onTap: () {
                        try {
                          AuthService().signOut();
                          snackbarCustom('Berhasil keluar');
                        } catch (e) {
                          snackbarCustom(e.message.toString());
                        }
                      },
                      title: Text('Logout'),
                      leading: Icon(Icons.logout))),
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
