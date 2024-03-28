import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabbarDiagnosaScreen extends StatelessWidget {
  final List<CheckupModel>? pemeriksaan;
  const TabbarDiagnosaScreen({Key? key, this.pemeriksaan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return pemeriksaan!.length == 0
        ? Center(child: Text('Belum ada data'))
        : SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(pemeriksaan!.length, (index) {
                  final data = pemeriksaan![index];
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                              'Keluhan ${DateFormat('dd/MM/yyyy').format(data.createdAt ?? DateTime.now())}'),
                          subtitle:
                              Text(data.riwayatKeluhan ?? 'Tidak ada keluhan'),
                        ),
                        ListTile(
                          title: const Text('Diagnosa'),
                          subtitle: Text(data.diagnosa ?? 'Tidak ada diagnosa'),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
  }
}
