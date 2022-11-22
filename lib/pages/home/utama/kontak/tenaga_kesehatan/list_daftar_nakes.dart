import 'package:eimunisasi/models/nakes.dart';
import 'package:eimunisasi/pages/widget/search_bar.dart';
import 'package:eimunisasi/services/nakes_database.dart';
import 'package:flutter/material.dart';

class ListDaftarNakes extends StatefulWidget {
  final nama;

  const ListDaftarNakes({Key key, @required this.nama}) : super(key: key);
  @override
  _ListDaftarNakesState createState() => _ListDaftarNakesState();
}

class _ListDaftarNakesState extends State<ListDaftarNakes> {
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
                  child: StreamBuilder<List<NakesModel>>(
                      stream: NakesDatabase().nakesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data;
                          return Column(
                            children: [
                              SearchBar(),
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
                                              data[index].nama,
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
                                        title: Text(data[index].telepon),
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.medical_services_rounded,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        title: Text(data[index].spesialis),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: CircularProgressIndicator());
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
