import 'package:eimunisasi/models/nakes.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/daftar_vaksinasi.dart';
import 'package:eimunisasi/services/nakes_service.dart';
import 'package:flutter/material.dart';

class ListNakes extends StatelessWidget {
  const ListNakes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Pilih nakes',
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
                    child: StreamBuilder<List<Nakes>>(
                      stream: NakesService().nakesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          if (snapshot.data != null) {
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DaftarVaksinasiPage(),
                                        ));
                                  },
                                  title: Text(
                                    data[index].namaLengkap,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  trailing:
                                      Icon(Icons.keyboard_arrow_right_rounded),
                                ));
                              },
                            );
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Center(
                          child: Text('Tidak ada data'),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
