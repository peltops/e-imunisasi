import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/models/nakes.dart';
import 'package:eimunisasi/core/widgets/search_bar.dart';
import 'package:eimunisasi/routers/route_paths/route_paths.dart';
import 'package:eimunisasi/services/nakes_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChooseNakesScreen extends StatelessWidget {
  final Anak anak;
  const ChooseNakesScreen({Key? key, required this.anak}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Pilih nakes',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.pink[100],
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Card(
            elevation: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SearchBarPeltops(),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: StreamBuilder<List<Nakes>>(
                      stream: NakesService().nakesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          if (data != null && data.length > 0) {
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final nakes = data[index];
                                return Card(
                                    child: ListTile(
                                  onTap: () {
                                    context.push(
                                      RoutePaths.makeAppointmentVaccination,
                                      extra: {
                                        'child': anak,
                                        'healthWorker': nakes,
                                      },
                                    );
                                  },
                                  title: Text(
                                    nakes.namaLengkap!,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Text(nakes.profesi ?? ""),
                                  trailing:
                                      Icon(Icons.keyboard_arrow_right_rounded),
                                ));
                              },
                            );
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Center(
                          child: Text('Tidak ada data'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
