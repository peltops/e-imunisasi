import 'package:eimunisasi/models/anak.dart';
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
            'Pilih Anak',
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
                        child: StreamBuilder<List<Anak>>(
                            stream: AnakService().anakStream,
                            builder:
                                (context, AsyncSnapshot<List<Anak>> snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data;

                                if (snapshot.data != null) {
                                  indexAnak = data.length;
                                  return ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                          child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AnakPage(
                                                anak: data[index],
                                              ),
                                            ),
                                          );
                                        },
                                        title: Text(
                                          data[index].nama,
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
                                return Center(
                                    child: CircularProgressIndicator());
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
