import 'package:flutter/material.dart';

class TabelTumbuhKembang extends StatefulWidget {
  const TabelTumbuhKembang({Key key}) : super(key: key);

  @override
  _TabelTumbuhKembangState createState() => _TabelTumbuhKembangState();
}

class _TabelTumbuhKembangState extends State<TabelTumbuhKembang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Buku Sehat',
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
                height: MediaQuery.of(context).size.height / 4,
                child: Card(
                    elevation: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                            child: SizedBox(
                          height: 100,
                          child: Image.network(
                              'https://picsum.photos/250?image=9'),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Cut Gambang',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text('Pr 0th 3bl 19 hr')
                      ],
                    )),
              ),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: SizedBox.expand(
                    child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tabel Tumbuh Kembang Anak',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
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
                                            (states) =>
                                                Theme.of(context).primaryColor),
                                    columns: <DataColumn>[
                                      DataColumn(
                                        label: Text(
                                          'Berat\nBadan',
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Tinggi\nBadan',
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Lingkar\nKepala',
                                        ),
                                      ),
                                    ],
                                    rows: <DataRow>[]),
                              ),
                            ],
                          ),
                        )),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
