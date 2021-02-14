import 'package:e_imunisasi/models/user.dart';
import 'package:e_imunisasi/pages/tumbuhKembang/tumbuhKembangPage.dart';
import 'package:e_imunisasi/services/auth.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bukusehatpage/bukusehatpage.dart';
import '../infopage/infopage.dart';
import '../kalenderpage/kalenderpage.dart';
import '../profilepage/profilepage.dart';

class Homepage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            return StreamProvider<TypeUser>.value(
                value: DatabaseService(uid: user.uid).typeUser,
                child: Homepage2());
          }
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}

class Homepage2 extends StatefulWidget {
  Homepage2({Key key}) : super(key: key);
  @override
  _Homepage2State createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isVerified = false;
  // final AuthService _auth = AuthService();

  // void get _displaySnackbar {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(
  //       duration: Duration(days: 365),
  //       content: Text('Silahkan verifikasi email anda!')));
  // }

  // cekVerified() async {
  //   dynamic result = await _auth.cekVerifiedEmail();
  //   setState(() {
  //     isVerified = result.isEmailVerified;
  //   });
  //   return !isVerified
  //       ? Future.delayed(Duration(seconds: 1)).then((_) => _displaySnackbar)
  //       : null;
  // }

  @override
  void initState() {
    super.initState();
    // cekVerified();
  }

  @override
  void dispose() {
    super.dispose();
    // cekVerified();
  }

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    KalenderPage(),
    BukuSehatPage(),
    TumbuhKembang(),
    InfoPage(),
    ProfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            // ignore: deprecated_member_use
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Buku Sehat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart),
            label: 'Statistik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Informasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.black38,
        elevation: 20.0,
        showUnselectedLabels: true,
        selectedIconTheme: IconThemeData(size: 26.0),
        onTap: _onItemTapped,
      ),
    );
  }
}
