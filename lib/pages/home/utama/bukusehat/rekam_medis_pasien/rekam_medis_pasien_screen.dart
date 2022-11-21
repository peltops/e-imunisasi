import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/models/checkup_model.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/tabbar_diagnosa/tabbar_diagnosa_screen.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/tabbar_grafik/tabbar_grafik_screen.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/tabbar_tabel/tabbar_tabel_screen.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/tabbar_tindakan/tabbar_tindakan_screen.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/tabbar_vaksin/tabbar_vaksin_screen.dart';
import 'package:eimunisasi/services/checkups_services.dart';
import 'package:flutter/material.dart';

class RekamMedisPasienScreen extends StatelessWidget {
  final Anak anak;
  const RekamMedisPasienScreen({Key key, this.anak}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Riwayat',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 6,
            child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                          child: SizedBox(
                        height: 80,
                        child:
                            Image.network('https://picsum.photos/250?image=9'),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            anak.nama,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Text(Anak().umurAnak(anak.tanggalLahir))
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          StreamBuilder<List<CheckupModel>>(
              stream: CheckupsServices().checkupsStream(anak.nik),
              builder: (context, snapshot) {
                var data = <CheckupModel>[];
                if (snapshot.hasData) {
                  data = snapshot.data;
                } else {
                  data = [];
                }
                return Expanded(
                  child: DefaultTabController(
                      length: 5,
                      child: Column(
                        children: [
                          Container(
                            color: Theme.of(context).primaryColor,
                            child: const TabBar(
                              indicatorColor: Colors.white,
                              isScrollable: true,
                              tabs: [
                                Tab(
                                  text: 'Vaksin',
                                ),
                                Tab(
                                  text: 'Tabel',
                                ),
                                Tab(
                                  text: 'Grafik',
                                ),
                                Tab(
                                  text: 'Diagnosa',
                                ),
                                Tab(
                                  text: 'Tindakan',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                TabbarVaksinScreen(
                                  pemeriksaan: data,
                                ),
                                TabbarTabelScreen(
                                  pemeriksaan: data,
                                ),
                                TabbarGrafikScreen(
                                  pemeriksaan: data,
                                  anak: anak,
                                ),
                                TabbarDiagnosaScreen(
                                  pemeriksaan: data,
                                ),
                                TabbarTindakanScreen(
                                  pemeriksaan: data,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                );
              }),
        ],
      ),
    );
  }
}