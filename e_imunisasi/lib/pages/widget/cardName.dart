import 'package:e_imunisasi/models/user.dart';
import 'package:flutter/material.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:provider/provider.dart';

class CardName extends StatelessWidget {
  cariUmur(String tglLahir) {
    DateTime birth = DateTime.parse(tglLahir);
    Duration dur = DateTime.now().difference(birth);
    String tahun = (dur.inDays / 365).floor().toString();
    String bulan = ((dur.inDays % 365) / 30).floor().toString();

    return tahun + " tahun " + bulan + " bulan ";
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
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 16.0),
                              leading: userData.avatarURL == null
                                  ? CircleAvatar(
                                      foregroundColor: Colors.white,
                                      radius: 50.0,
                                      child: Text(
                                        userData.nama.substring(0, 1),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          NetworkImage(userData.avatarURL),
                                    ),
                              title: Text(
                                userData.nama,
                                style: TextStyle(fontSize: 20.0),
                              ),
                              subtitle: userData.tgllahir == ''
                                  ? Text(
                                      'Mohon untuk mengisi data diri terlebih dahulu')
                                  : Text(
                                      'Umur : ' +
                                          cariUmur('${userData.tgllahir}'),
                                    ),
                            ),
                          ],
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
