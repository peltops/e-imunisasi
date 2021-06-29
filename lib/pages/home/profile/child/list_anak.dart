import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/pages/home/profile/child/anak.dart';
import 'package:eimunisasi/pages/home/profile/child/daftar_anak.dart';
import 'package:flutter/material.dart';
import 'package:eimunisasi/services/anak_database.dart';

class ListAnak extends StatelessWidget {
  const ListAnak({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int indexAnak = 0;

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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Card(
                        elevation: 0,
                        child: StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                            stream: AnakService().documentStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var data;
                                if (snapshot.data.data() != null) {
                                  data = snapshot.data;
                                  indexAnak = data.data().length;

                                  return ListView.builder(
                                    itemCount: data.data().length,
                                    itemBuilder: (context, index) {
                                      index = index + 1;
                                      return Card(
                                          child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnakPage(
                                                        nama: data[index
                                                                .toString()]
                                                            ['nama'],
                                                        nik: data[index
                                                            .toString()]['nik'],
                                                        tempatLahir: data[index
                                                                .toString()]
                                                            ['tempat_lahir'],
                                                        tanggalLahir: data[index
                                                                .toString()]
                                                            ['tanggal_lahir'],
                                                        jenisKelamin: data[index
                                                                .toString()]
                                                            ['jenis_kelamin'],
                                                        golDarah: data[index
                                                                .toString()]
                                                            ['gol_darah'],
                                                        indexAnak: index - 1,
                                                      )));
                                        },
                                        title: Text(
                                          data[index.toString()]['nama'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        trailing: Icon(
                                            Icons.keyboard_arrow_right_rounded),
                                      ));
                                    },
                                  );
                                }
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LinearProgressIndicator();
                              }
                              return Center(
                                child: Text('Tidak ada data'),
                              );
                            })),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DaftarAnakPage(
                        indexAnak: indexAnak,
                      ))),
        ));
  }
}
