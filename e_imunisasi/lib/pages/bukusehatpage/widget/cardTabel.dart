import 'package:e_imunisasi/models/user.dart';
import 'package:flutter/material.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:provider/provider.dart';

class CardTabelRiwayatImunisasiAnak extends StatelessWidget {
  cariUmur(String tglLahir) {
    DateTime birth = DateTime.parse(tglLahir);
    Duration dur = DateTime.now().difference(birth);
    return (dur.inDays / 365).floor().toString();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<List<DataRiwayatImunisasi>>(
        stream: DatabaseService(uid: user.uid, email: user.email)
            .dataRiwayatImunisasi('idPeserta'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DataRiwayatImunisasi> listData = snapshot.data;
            return Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    shadowColor: Colors.deepOrange[100],
                    elevation: 5.0,
                    child: Column(
                      children: [
                        SizedBox(height: 10.0),
                        Text(
                          "Riwayat Imunisasi",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fill,
                          child: DataTable(
                              horizontalMargin: 20.0,
                              columns: <DataColumn>[
                                DataColumn(label: Text("No")),
                                DataColumn(label: Text("Tanggal")),
                                DataColumn(label: Text("Jenis Vaksin")),
                                DataColumn(label: Text("Tenaga Medis")),
                              ],
                              rows: List<DataRow>.generate(
                                listData.length,
                                (index) => DataRow(cells: [
                                  DataCell(Text((index + 1).toString()),
                                      onTap: () {
                                    print('Tekan');
                                  }),
                                  DataCell(Text(listData[index]
                                          .takeDate
                                          .toString()
                                          .split(' ')[0] ??
                                      'Kosong')),
                                  DataCell(Text(
                                      listData[index].jenisVaksin ?? 'Kosong')),
                                  DataCell(Text(
                                      listData[index].namaMedis ?? 'Kosong')),
                                ]),
                              )),
                        ),
                      ],
                    ),
                  ),
                ));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
