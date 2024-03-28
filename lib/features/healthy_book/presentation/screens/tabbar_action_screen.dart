import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabBarActionScreen extends StatelessWidget {
  final List<CheckupModel>? checkup;

  const TabBarActionScreen({
    Key? key,
    this.checkup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (checkup == null || checkup?.length == 0) {
      return Center(child: Text('Belum ada data'));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(
            checkup?.length ?? 0,
            (index) {
              final data = checkup![index];
              return Card(
                child: ListTile(
                  title: Text(
                    'Tindakan ${DateFormat('dd/MM/yyyy').format(data.createdAt ?? DateTime.now())}',
                  ),
                  subtitle: Text(
                    data.tindakan ?? 'Tidak ada tindakan yang dilakukan',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
