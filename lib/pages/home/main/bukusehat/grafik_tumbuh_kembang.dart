import 'package:eimunisasi/pages/home/main/bukusehat/grafik.dart';
import 'package:flutter/material.dart';

class GrafikTumbuhKembang extends StatefulWidget {
  const GrafikTumbuhKembang({Key key}) : super(key: key);

  @override
  _GrafikTumbuhKembangState createState() => _GrafikTumbuhKembangState();
}

class _GrafikTumbuhKembangState extends State<GrafikTumbuhKembang> {
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
              Expanded(
                  // width: double.infinity,
                  // height: MediaQuery.of(context).size.height / 2,
                  child: SizedBox.expand(
                child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Grafik Tumbuh Kembang Anak',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: SimpleTimeSeriesChart.withSampleData()),
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
