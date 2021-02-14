import 'package:e_imunisasi/models/user.dart';

import 'package:flutter/material.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:provider/provider.dart';

class CardTabelTumbuh extends StatelessWidget {
  cariUmur(String tglLahir) {
    DateTime birth = DateTime.parse(tglLahir);
    Duration dur = DateTime.now().difference(birth);
    return (dur.inDays / 365).floor().toString();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<List<DataTumbuh>>(
        stream:
            DatabaseService(uid: user.uid).dataPerkembangan(true, 'idPeserta'),
        builder:
            (BuildContext context, AsyncSnapshot<List<DataTumbuh>> snapshot) {
          if (snapshot.hasData) {
            List<DataTumbuh> listData = snapshot.data;
            return Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    shadowColor: Colors.deepOrange[100],
                    elevation: 5.0,
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.fill,
                          child: DataTable(
                              horizontalMargin: 20.0,
                              columns: <DataColumn>[
                                DataColumn(label: Text("No")),
                                DataColumn(label: Text("Tanggal")),
                                DataColumn(
                                    label: Text(
                                  "Berat\nbadan",
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text("Tinggi\nbadan",
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label: Text("Lingkar\nbadan",
                                        textAlign: TextAlign.center)),
                              ],
                              rows: List<DataRow>.generate(
                                listData.length,
                                (index) => DataRow(cells: [
                                  DataCell(Text((index + 1).toString())),
                                  DataCell(Text(listData[index]
                                      .takeDate
                                      .toString()
                                      .split(' ')[0])),
                                  DataCell(Text(listData[index].beratBadan)),
                                  DataCell(Text(listData[index].tinggiBadan)),
                                  DataCell(Text(listData[index].lingkarBadan)),
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
