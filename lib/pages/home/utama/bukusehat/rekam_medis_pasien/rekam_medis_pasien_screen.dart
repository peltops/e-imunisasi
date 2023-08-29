import 'package:cached_network_image/cached_network_image.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/models/checkup_model.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/tabbar_diagnosa/tabbar_diagnosa_screen.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/tabbar_grafik/tabbar_grafik_screen.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/tabbar_tabel/tabbar_tabel_screen.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/tabbar_tindakan/tabbar_tindakan_screen.dart';
import 'package:eimunisasi/pages/home/utama/bukusehat/rekam_medis_pasien/tabbar_vaksin/tabbar_vaksin_screen.dart';
import 'package:eimunisasi/services/checkups_services.dart';
import 'package:flutter/material.dart';

class RekamMedisPasienScreen extends StatelessWidget {
  final Anak? anak;
  const RekamMedisPasienScreen({Key? key, this.anak}) : super(key: key);

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
                          width: 80,
                          child: CachedNetworkImage(
                            imageUrl: anak!.photoURL!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => FittedBox(
                              child: Icon(
                                Icons.supervised_user_circle_sharp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            anak!.nama!,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Text(anak!.umurAnak)
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          StreamBuilder<List<CheckupModel>>(
              stream: CheckupsServices().checkupsStream(anak!.nik),
              builder: (context, snapshot) {
                List<CheckupModel>? data = <CheckupModel>[];
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
