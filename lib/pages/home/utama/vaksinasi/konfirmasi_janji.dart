import 'package:eimunisasi/models/appointment.dart';
import 'package:eimunisasi/pages/home/home.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class KonfirmasiVaksinasiPage extends StatefulWidget {
  final AppointmentModel appointment;

  const KonfirmasiVaksinasiPage({Key key, @required this.appointment})
      : super(key: key);
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
                          child: QrImage(
                            data: widget.appointment.id,
                            size: size.width * 0.5,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Konfirmasi Janji',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Janji dengan Nakes telah dibuat. Lihat detail Informasi berikut: ',
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
                                  widget.appointment.anak.nama,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  widget.appointment.anak.umurAnak,
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
                                  widget.appointment.nakes.namaLengkap,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  widget.appointment.nakes.profesi,
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
                                DateFormat('dd MMMM yyyy')
                                    .format(widget.appointment.tanggal),
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'Jam :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                widget.appointment.desc.split(', ')[1],
                              ),
                            ]),
                          ],
                        ),
                        SizedBox(height: 30),
                        ButtonCustom(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false);
                          },
                          child: Text(
                            'Halaman Utama',
                            style: TextStyle(color: Colors.white),
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
