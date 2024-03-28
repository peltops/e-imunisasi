import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabbarTindakanScreen extends StatelessWidget {
  final List<CheckupModel>? pemeriksaan;
  const TabbarTindakanScreen({Key? key, this.pemeriksaan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return pemeriksaan!.length == 0
        ? Center(child: Text('Belum ada data'))
        : SingleChildScrollView(
            child: Column(
              children: [
                pemeriksaan!.length == 0
                    ? Center(child: Text('Belum ada data'))
                    : Container(),
                ...List.generate(pemeriksaan!.length, (index) {
                  final data = pemeriksaan![index];
                  return Card(
                    child: ListTile(
                      title: Text(
                          'Tindakan ${DateFormat('dd/MM/yyyy').format(data.createdAt ?? DateTime.now())}'),
                      subtitle: Text(
                          data.tindakan ?? 'Tidak ada tindakan yang dilakukan'),
                    ),
                  );
                }),
              ],
            ),
          );
  }
}
