import 'package:eimunisasi/pages/home/main/kontak/list_daftar_nakes.dart';
import 'package:flutter/material.dart';

class DaftarNakes extends StatefulWidget {
  @override
  _DaftarNakesState createState() => _DaftarNakesState();
}

class _DaftarNakesState extends State<DaftarNakes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            "Kontak",
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
                          child: ListTile(
                        onTap: null,
                        title: Center(child: Text('Tenaga Kesehatan')),
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Flexible(
                        child: GridView.count(
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          crossAxisCount: 2,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ListDaftarNakes(
                                                nama: 'Dokter',
                                              )));
                                },
                                child: Text('Dokter')),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ListDaftarNakes(
                                                nama: 'Perawat',
                                              )));
                                },
                                child: Text('Perawat')),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ListDaftarNakes(
                                                nama: 'Bidan',
                                              )));
                                },
                                child: Text('Bidan')),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ListDaftarNakes(
                                                nama: 'Ahli Gizi',
                                              )));
                                },
                                child: Text('Ahli Gizi')),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ));
  }
}
