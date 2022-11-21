import 'package:eimunisasi/models/anak.dart';
import 'package:eimunisasi/models/checkup_model.dart';
import 'package:eimunisasi/services/checkups_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatPage extends StatefulWidget {
  final nama, nik, tempatLahir, tanggalLahir, jenisKelamin, golDarah, indexAnak;
  const RiwayatPage({
    Key key,
    @required this.nama,
    @required this.nik,
    @required this.tempatLahir,
    @required this.tanggalLahir,
    @required this.jenisKelamin,
    @required this.golDarah,
    @required this.indexAnak,
  }) : super(key: key);

  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
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
      body: Container(
        color: Colors.pink[100],
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
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
                            child: Image.network(
                                'https://picsum.photos/250?image=9'),
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
                                widget.nama,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              Text(Anak(tanggalLahir: widget.tanggalLahir)
                                  .umurAnak)
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
              StreamBuilder<List<CheckupModel>>(
                  stream: CheckupsServices().checkupsStream(widget.nik),
                  builder: (context, snapshot) {
                    var data = <CheckupModel>[];
                    if (snapshot.hasData) {
                      data = snapshot.data;
                    } else {
                      data = [];
                    }
                    return Expanded(
                        child: SizedBox.expand(
                      child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Riwayat Vaksinasi',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: DataTable(
                                        headingTextStyle: TextStyle(
                                            fontFamily: 'Nunito',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        dataTextStyle: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: Colors.black,
                                        ),
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Theme.of(context)
                                                    .primaryColor),
                                        columns: <DataColumn>[
                                          DataColumn(
                                            label: Text(
                                              'Nama Vaksin',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Tanggal',
                                            ),
                                          ),
                                        ],
                                        rows: [
                                          if (data.length > 0)
                                            for (var i = 0;
                                                i < data.length;
                                                i++)
                                              DataRow(cells: [
                                                DataCell(Text(
                                                    data[i].jenisVaksin ?? '')),
                                                DataCell(Text(DateFormat(
                                                        'dd MM yyyy')
                                                    .format(
                                                        data[i].createdAt))),
                                              ]),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
