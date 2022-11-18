import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/list_nakes_vaksinasi.dart';
import 'package:flutter/material.dart';
import 'package:eimunisasi/services/anak_database.dart';

class ListAnakVaksinasi extends StatelessWidget {
  final page;
  const ListAnakVaksinasi({Key key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Pilih anak',
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
                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                        child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ListNakes(),
                                            ));
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
                              return Center(child: CircularProgressIndicator());
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
    );
  }
}
