import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabbarVaksinScreen extends StatelessWidget {
  final List<CheckupModel>? pemeriksaan;
  const TabbarVaksinScreen({Key? key, this.pemeriksaan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return pemeriksaan!.length == 0
        ? Center(child: Text('Belum ada data'))
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: DataTable(
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: Colors.black,
                ),
                columns: const [
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Vaksin')),
                ],
                rows: [
                  ...pemeriksaan!.map((data) {
                    return DataRow(cells: [
                      DataCell(Text(DateFormat('dd/MM/yyyy')
                          .format(data.createdAt ?? DateTime.now()))),
                      DataCell(Text(data.jenisVaksin ?? '')),
                    ]);
                  }).toList(),
                ],
              ),
            ),
          );
  }
}
