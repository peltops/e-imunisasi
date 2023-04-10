import 'package:eimunisasi/models/rumah_sakit.dart';
import 'package:eimunisasi/services/rumah_sakit_database.dart';
import 'package:flutter/material.dart';

class ListDaftarRumahSakit extends StatefulWidget {
  final nama;

  const ListDaftarRumahSakit({Key? key, this.nama = 'Rumah Sakit'})
      : super(key: key);
  @override
  _ListDaftarRumahSakitState createState() => _ListDaftarRumahSakitState();
}

class _ListDaftarRumahSakitState extends State<ListDaftarRumahSakit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            'Daftar ${widget.nama}',
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
                  child: StreamBuilder<List<RumahSakitModel>>(
                      stream: RumahSakitDatabase().streamData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!;
                          return Column(
                            children: [
                              Flexible(
                                  child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) => Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Card(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              data[index].nama!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )),
                                      ListTile(
                                        leading: Icon(
                                          Icons.phone,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        title: Text(data[index].telepon!),
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.maps_home_work_rounded,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        title: Text(data[index].alamat!),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error'),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              )),
        ));
  }
}
