import 'package:cached_network_image/cached_network_image.dart';
import 'package:eimunisasi/features/healthy_book/presentation/screens/tabbar_action_screen.dart';
import 'package:eimunisasi/features/healthy_book/presentation/screens/tabbar_chart_screen.dart';
import 'package:eimunisasi/features/healthy_book/presentation/screens/tabbar_diagnosa_screen.dart';
import 'package:eimunisasi/features/healthy_book/presentation/screens/tabbar_table_screen.dart';
import 'package:eimunisasi/features/healthy_book/presentation/screens/tabbar_vaccine_screen.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../logic/blocs/checkupBloc/checkup_bloc.dart';

class PatientMedicalHistoryScreen extends StatelessWidget {
  final Anak? child;

  const PatientMedicalHistoryScreen({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CheckupBloc>()
        ..add(OnGetCheckupsEvent(
          childId: child?.id,
        )),
      child: BlocBuilder<CheckupBloc, CheckupState>(
        builder: (context, state) {
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
            body: () {
              if (state.statusGet == FormzSubmissionStatus.success) {
                return PatientMedicalHistoryScaffold(
                  child: child,
                );
              } else if (state.statusGet == FormzSubmissionStatus.inProgress) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Scaffold(
                  body: Center(
                    child: Text('Gagal memuat data'),
                  ),
                );
              }
            }(),
          );
        },
      ),
    );
  }
}

class PatientMedicalHistoryScaffold extends StatelessWidget {
  final Anak? child;

  const PatientMedicalHistoryScaffold({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        child: child?.photoURL == null
                            ? Icon(
                                Icons.supervised_user_circle_sharp,
                              )
                            : CachedNetworkImage(
                                imageUrl: child?.photoURL ?? '',
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
                          child?.nama ?? '',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text(child?.umurAnak ?? ''),
                      ],
                    ),
                  ],
                ),
              )),
        ),
        BlocBuilder<CheckupBloc, CheckupState>(
          builder: (context, state) {
            final data = state.checkups;
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
                          Tab(text: 'Vaksin'),
                          Tab(text: 'Tabel'),
                          Tab(text: 'Grafik'),
                          Tab(text: 'Diagnosa'),
                          Tab(text: 'Tindakan'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          TabBarVaccineScreen(
                            checkup: data,
                          ),
                          TabBarTableScreen(
                            checkup: data,
                          ),
                          TabBarChartScreen(
                            checkup: data,
                            child: child,
                          ),
                          TabBarDiagnosisScreen(
                            checkup: data,
                          ),
                          TabBarActionScreen(
                            checkup: data,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
