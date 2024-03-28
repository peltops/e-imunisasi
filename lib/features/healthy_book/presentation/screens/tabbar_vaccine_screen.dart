import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabBarVaccineScreen extends StatelessWidget {
  final List<CheckupModel>? checkup;

  const TabBarVaccineScreen({
    Key? key,
    this.checkup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (checkup == null || checkup?.length == 0) {
      return Center(child: Text('Belum ada data'));
    }
    return SingleChildScrollView(
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
            ...?checkup?.map((data) {
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
