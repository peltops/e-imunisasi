import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DaftarVaksinasiPage extends StatefulWidget {
  @override
  _DaftarVaksinasiPageState createState() => _DaftarVaksinasiPageState();
}

class _DaftarVaksinasiPageState extends State<DaftarVaksinasiPage> {
  String _tanggal = 'Pilih tanggal';
  int selectedRadioTile;

  final kFirstDay = DateTime.now();
  final kLastDay = DateTime(DateTime.now().year + 1);
  @override
  void initState() {
    selectedRadioTile = 0;
    super.initState();
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            "Buat janji",
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
                        Text(
                          'NAMA NAKES',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Jadwal Praktek',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Hari 1- Hari 7 20.00 - 22.00',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Jadwal Praktek Imunisasi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.all(0),
                          value: 1,
                          groupValue: selectedRadioTile,
                          title: Text('Senin 20.00 - 22.00'),
                          onChanged: setSelectedRadioTile,
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.all(0),
                          value: 2,
                          groupValue: selectedRadioTile,
                          title: Text('Rabu 7 20.00 - 22.00'),
                          onChanged: setSelectedRadioTile,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                theme: DatePickerTheme(
                                  doneStyle: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Buat Janji'),
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
