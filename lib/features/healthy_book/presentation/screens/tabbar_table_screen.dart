import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabBarTableScreen extends StatelessWidget {
  final List<CheckupModel>? checkup;

  const TabBarTableScreen({
    Key? key,
    this.checkup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DataRow> listBodyTable = List.generate(
      checkup?.length ?? 0,
      (index) {
        final data = checkup![index];
        return DataRow(cells: [
          DataCell(Text(DateFormat('dd/MM/yyyy')
              .format(data.createdAt ?? DateTime.now()))),
          DataCell(Text(data.beratBadan?.toString() ?? '')),
          DataCell(Text(data.tinggiBadan?.toString() ?? '')),
          DataCell(Text(data.lingkarKepala?.toString() ?? '')),
        ]);
      },
    );
    if (checkup == null || checkup?.length == 0) {
      return Center(child: Text('Belum ada data'));
    }

    return SingleChildScrollView(
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
