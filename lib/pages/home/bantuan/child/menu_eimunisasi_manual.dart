import 'package:eimunisasi/models/informasi_aplikasi.dart';
import 'package:eimunisasi/pages/home/bantuan/child/detail_informasi.dart';
import 'package:eimunisasi/pages/widget/search_bar.dart';
import 'package:eimunisasi/services/informasi_aplikasi_database.dart';
import 'package:flutter/material.dart';

class EimunisasiManualPage extends StatefulWidget {
  const EimunisasiManualPage({Key? key}) : super(key: key);
  @override
  _EimunisasiManualPageState createState() => _EimunisasiManualPageState();
}

class _EimunisasiManualPageState extends State<EimunisasiManualPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            'Informasil Aplikasi',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
            color: Colors.pink[100],
            child: Card(
              margin: EdgeInsets.all(20),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchBarPeltops(),
                    SizedBox(height: 10),
                    Expanded(
                      child: StreamBuilder<List<InformasiAplikasiModel>>(
                          stream: InformasiAplikasiDatabase().streamData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!;
                              return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailInformasiPage(
                                                          data: data[index])));
                                        },
                                        title: Text(data[index].judul!),
                                      ),
                                    );
                                  });
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error'),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    )
                  ],
                ),
              ),
            )));
  }
}
