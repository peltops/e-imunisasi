import 'package:eimunisasi/features/healthy_book/data/models/chart/head_circumference_chart.dart';
import 'package:eimunisasi/features/healthy_book/data/models/chart/weight_chart.dart';
import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:flutter/material.dart';

import '../../../profile/data/models/child_model.dart';
import '../../data/models/chart/height_chart.dart';

class TabBarChartScreen extends StatelessWidget {
  final List<CheckupModel>? checkup;
  final ChildModel? child;
  const TabBarChartScreen({
    Key? key,
    this.checkup,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Berat Badan'),
                Tab(text: 'Tinggi Badan'),
                Tab(text: 'Lingkar Kepala'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: (checkup?.length ?? 0) > 0
                  ? [
                      GrafikBeratBadan(
                        listData: checkup,
                        isBoy: child?.jenisKelamin != 'Perempuan',
                      ),
                      GrafikTinggiBadan(
                        listData: checkup,
                        isBoy: child?.jenisKelamin != 'Perempuan',
                      ),
                      GrafikLingkarKepala(
                        listData: checkup,
                        isBoy: child?.jenisKelamin != 'Perempuan',
                      ),
                    ]
                  : [
                      Center(child: Text('Belum ada data')),
                      Center(child: Text('Belum ada data')),
                      Center(child: Text('Belum ada data')),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
