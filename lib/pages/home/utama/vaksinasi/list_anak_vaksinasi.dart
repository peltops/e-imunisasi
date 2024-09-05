import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/routers/route_paths/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:eimunisasi/services/anak_database.dart';
import 'package:go_router/go_router.dart';

class ListAnakVaksinasi extends StatelessWidget {
  final page;
  const ListAnakVaksinasi({Key? key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Pilih anak',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.pink[100],
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Card(
                      elevation: 0,
                      child: StreamBuilder<List<Anak>>(
                          stream: AnakService().anakStream,
                          builder:
                              (context, AsyncSnapshot<List<Anak>> snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data;
                              if (data != null && data.length > 0) {
                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final anak = data[index];
                                    return Card(
                                        child: ListTile(
                                      onTap: () {
                                        context.push(
                                          RoutePaths.chooseHealthWorkers,
                                          extra: anak,
                                        );
                                      },
                                      title: Text(
                                        anak.nama!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      subtitle: Text(anak.umurAnak),
                                      trailing: Icon(
                                          Icons.keyboard_arrow_right_rounded),
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
                          })),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
