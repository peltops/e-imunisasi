import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/models/checkup_model.dart';
import 'package:eimunisasi/models/grafik/grafik_berat_badan.dart';
import 'package:eimunisasi/models/grafik/grafik_lingkar_kepala.dart';
import 'package:eimunisasi/models/grafik/grafik_tinggi_badan.dart';
import 'package:flutter/material.dart';

class TabbarGrafikScreen extends StatelessWidget {
  final List<CheckupModel>? pemeriksaan;
  final Anak? anak;
  const TabbarGrafikScreen({
    Key? key,
    this.pemeriksaan,
    required this.anak,
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
              children: pemeriksaan!.length > 0
                  ? [
                      GrafikBeratBadan(
                        listData: pemeriksaan,
                        isBoy: anak!.jenisKelamin != 'Perempuan',
                      ),
                      GrafikTinggiBadan(
                        listData: pemeriksaan,
                        isBoy: anak!.jenisKelamin != 'Perempuan',
                      ),
                      GrafikLingkarKepala(
                        listData: pemeriksaan,
                        isBoy: anak!.jenisKelamin != 'Perempuan',
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
