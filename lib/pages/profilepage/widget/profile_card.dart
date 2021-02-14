import 'package:e_imunisasi/models/user.dart';
import 'package:e_imunisasi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:provider/provider.dart';
import 'package:e_imunisasi/pages/profilepage/personalpage.dart';

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isVerified = false;

  final AuthService _auth = AuthService();
  cekVerified() async {
    dynamic result = await _auth.cekVerifiedEmail();

    setState(() {
      isVerified = result.isEmailVerified;
    });
  }

  @override
  void initState() {
    super.initState();
    cekVerified();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final typeUser = Provider.of<TypeUser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid, email: user.email)
            .userData(typeUser.typeUser),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: Center(
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        shadowColor: Colors.deepOrange[100],
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 16.0),
                          child: Column(
                            children: [
                              userData.avatarURL == null
                                  ? CircleAvatar(
                                      foregroundColor: Colors.white,
                                      radius: 50,
                                      child: Text(
                                        userData.nama.substring(0, 1),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          NetworkImage(userData.avatarURL),
                                    ),
                              ListTile(
                                title: Text(
                                  userData.nama,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                subtitle: isVerified
                                    ? Text(
                                        userData.email + ' (Terverifikasi)',
                                        textAlign: TextAlign.center,
                                      )
                                    : Text(
                                        userData.email +
                                            ' (Belum Terverifikasi)',
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        shadowColor: Colors.deepOrange[100],
                        elevation: 5.0,
                        child: ListTile(
                          title: Text(
                            "Personal Data",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PersonalPage(
                                        typeUser: typeUser.typeUser)));
                          },
                        ),
                      ),
                    ],
                  ),
                ));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
