import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabbarTabelScreen extends StatelessWidget {
  final List<CheckupModel>? pemeriksaan;
  const TabbarTabelScreen({Key? key, this.pemeriksaan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DataRow> listBodyTable =
        List.generate(pemeriksaan!.length, (index) {
      final data = pemeriksaan![index];
      return DataRow(cells: [
        DataCell(Text(
            DateFormat('dd/MM/yyyy').format(data.createdAt ?? DateTime.now()))),
        DataCell(Text(data.beratBadan?.toString() ?? '')),
        DataCell(Text(data.tinggiBadan?.toString() ?? '')),
        DataCell(Text(data.lingkarKepala?.toString() ?? '')),
      ]);
    });

    return pemeriksaan!.length == 0
        ? Center(child: Text('Belum ada data'))
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: DataTable(
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: Colors.black,
                ),
                columns: const [
                  DataColumn(
                    label: Text('Tanggal'),
                  ),
                  DataColumn(
                    label: Text('BB (KG)'),
                  ),
                  DataColumn(
                    label: Text('TB (CM)'),
                  ),
                  DataColumn(
                    label: Text('LK (CM)'),
                  ),
                ],
                rows: [
                  ...listBodyTable,
                ],
              ),
            ),
          );
  }
}
