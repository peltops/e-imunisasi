import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DaftarVaksinasiPage extends StatefulWidget {
  @override
  _DaftarVaksinasiPageState createState() => _DaftarVaksinasiPageState();
}

class _DaftarVaksinasiPageState extends State<DaftarVaksinasiPage> {
  String _tanggal = 'Pilih tanggal';
  String _jam = 'Pilih jam';

  final kFirstDay = DateTime.now();
  final kLastDay = DateTime(DateTime.now().year + 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            "Pilihan",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: SizedBox.expand(
          child: Container(
              color: Colors.pink[100],
              child: Card(
                margin: EdgeInsets.all(20),
                elevation: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Tenaga Kesehatan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 200,
                        child: Card(
                            child: ListTile(
                          onTap: null,
                          leading: Icon(
                            Icons.medical_services_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          title: Text('Vaksinasi'),
                        )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Tentukan Waktu Vaksinasi',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                          child: ListTile(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(
                                doneStyle: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                              showTitleActions: true,
                              minTime: kFirstDay,
                              maxTime: kLastDay, onConfirm: (val) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(val);
                            setState(() {
                              _tanggal = formattedDate.toString();
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.id);
                        },
                        trailing: Icon(
                          Icons.date_range,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        title: Text(_tanggal),
                      )),
                      Card(
                          child: ListTile(
                        onTap: () {
                          DatePicker.showTimePicker(context,
                              showSecondsColumn: false,
                              showTitleActions: true, onConfirm: (date) {
                            String formattedDate =
                                DateFormat('HH:mm').format(date);
                            setState(() {
                              _jam = formattedDate.toString();
                            });
                          }, currentTime: DateTime.now());
                        },
                        trailing: Icon(
                          Icons.timer,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        title: Text(_jam),
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: null,
                                title: Text(
                                    'Permintaan Vaksinasis akan dikirim sesuai pilihan anda'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Batal')),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: null, child: Text('Setuju'))
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              )),
        ));
  }
}
