import 'package:flutter/material.dart';

class ListDaftarKlinik extends StatefulWidget {
  final nama;

  const ListDaftarKlinik({Key key, this.nama = 'klinik'}) : super(key: key);
  @override
  _ListDaftarKlinikState createState() => _ListDaftarKlinikState();
}

class _ListDaftarKlinikState extends State<ListDaftarKlinik> {
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                          color: Theme.of(context).accentColor,
                          child: ListTile(
                            onTap: null,
                            title: Center(
                                child: Text(
                              'Daftar ${widget.nama}',
                              style: TextStyle(color: Colors.white),
                            )),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Flexible(
                          child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) => Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Text('klinik ${index + 1}')),
                              ListTile(
                                leading: Icon(
                                  Icons.local_hospital_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text('Nama rumah sakit ${index + 1}'),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.phone,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text('Telepon ${index + 1}'),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.smartphone_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text('HP ${index + 1}'),
                              )
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              )),
        ));
  }
}
