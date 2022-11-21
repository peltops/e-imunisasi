import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class KonfirmasiVaksinasiPage extends StatefulWidget {
  @override
  _KonfirmasiVaksinasiPageState createState() =>
      _KonfirmasiVaksinasiPageState();
}

class _KonfirmasiVaksinasiPageState extends State<KonfirmasiVaksinasiPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            "Janji",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: SizedBox.expand(
          child: Container(
              color: Colors.pink[100],
              child: Card(
                margin: EdgeInsets.all(20),
                elevation: 0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://www.cilips.org.uk/wp-content/uploads/2021/09/qr-code-7.png',
                            imageBuilder: (context, imageProvider) => Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              width: 200,
                              height: 200,
                              child: FittedBox(
                                  child: Shimmer(
                                      gradient: LinearGradient(colors: [
                                        Colors.grey[300],
                                        Colors.grey[100]
                                      ]),
                                      child: Icon(Icons.qr_code))),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 200,
                              height: 200,
                              child: FittedBox(
                                  child: Icon(
                                Icons.error,
                                color: Colors.red[300],
                              )),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Konfirmasi Janji',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Janji dengan Nakes telah dibuat. Lihat detal Informasi berikut',
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.pink[300],
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama Pasien',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  'Umur',
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.pink[300],
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama Nakes',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  'Nama Klinik',
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Table(
                          children: [
                            TableRow(children: [
                              Text(
                                'Tanggal :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                '28 Januari 2021',
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'Jam :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                '20.00',
                              ),
                            ]),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Halaman Utama'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ));
  }
}
