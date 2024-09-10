import 'package:eimunisasi/models/informasi_kesehatan.dart';
import 'package:eimunisasi/core/widgets/search_bar.dart';
import 'package:eimunisasi/routers/route_paths/route_paths.dart';
import 'package:eimunisasi/services/informasi_kesehatan_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InformasiKesehatanPage extends StatefulWidget {
  const InformasiKesehatanPage({Key? key}) : super(key: key);
  @override
  _InformasiKesehatanPageState createState() => _InformasiKesehatanPageState();
}

class _InformasiKesehatanPageState extends State<InformasiKesehatanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            'Informasi kesehatan',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
            color: Colors.pink[100],
            child: Card(
              margin: EdgeInsets.all(20),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SearchBarPeltops(),
                    SizedBox(height: 10),
                    Expanded(
                      child: StreamBuilder<List<InformasiKesehatanModel>>(
                          stream: InformasiKesehatanDatabase().streamData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!;
                              return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        onTap: () {
                                          context.push(
                                            RoutePaths.detailInformasi,
                                            extra: data[index],
                                          );
                                        },
                                        title: Text(data[index].judul!),
                                      ),
                                    );
                                  });
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error'),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    )
                  ],
                ),
              ),
            )));
  }
}
