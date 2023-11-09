import 'package:eimunisasi/models/appointment.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/konfirmasi_janji.dart';
import 'package:eimunisasi/services/appointment_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ListJanjiVaksinasi extends StatelessWidget {
  final page;
  const ListJanjiVaksinasi({Key? key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Pilih Janji',
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
                    child: FutureBuilder<List<AppointmentModel>>(
                      future: AppointmentService(uid: currentUser.uid)
                          .getAppointment(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          if (data != null && data.length > 0) {
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final appointment = data[index];
                                return Card(
                                    child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              KonfirmasiVaksinasiPage(
                                            appointment: appointment,
                                          ),
                                        ));
                                  },
                                  title: Text(
                                    appointment.anak!.nama! +
                                        ' (${appointment.anak!.umurAnak})',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat('dd MMMM yyyy')
                                        .format(appointment.tanggal!),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
