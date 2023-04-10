import 'package:eimunisasi/models/calendar.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/calendar_database.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_signin_button/flutter_signin_button.dart';

class UpdateEventCalendar extends StatefulWidget {
  final docID;
  final KalenderModel? data;

  const UpdateEventCalendar({Key? key, this.docID, this.data}) : super(key: key);
  @override
  _UpdateEventCalendarState createState() => _UpdateEventCalendarState();
}

class _UpdateEventCalendarState extends State<UpdateEventCalendar> {
  final _formKey = GlobalKey<FormState>();
  //Email and Pass state
  bool loading = false;
  final kFirstDay = DateTime(DateTime.now().year - 1);
  final kLastDay = DateTime(DateTime.now().year + 1);
  TextEditingController? _dateTimeCtrl;
  late TextEditingController _activityCtrl;

  @override
  void initState() {
    _dateTimeCtrl =
        TextEditingController(text: widget.data!.date.toString().split(' ')[0]);
    _activityCtrl = TextEditingController(text: widget.data!.activity);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Perbarui Aktivitas'),
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.pink[100],
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 35, horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                  child: SingleChildScrollView(
                      child: Form(
                    key: _formKey,
                    child: KeyboardAvoider(
                      child: Column(children: [
                        SizedBox(height: 5.0),
                        TextFormCustom(
                          onTap: () {
                            DateTime tempDate = new DateFormat("yyyy-MM-dd")
                                .parse(_dateTimeCtrl!.text);
                            DatePicker.showDatePicker(context,
                                theme: DatePickerTheme(
                                  doneStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                  ),
                                  cancelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                    color: Colors.black,
                                  ),
                                  itemStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                showTitleActions: true,
                                minTime: kFirstDay,
                                maxTime: kLastDay, onConfirm: (val) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(val);
                              setState(() {
                                _dateTimeCtrl!.text = formattedDate.toString();
                              });
                            }, currentTime: tempDate, locale: LocaleType.id);
                          },
                          label: 'Tanggal',
                          readOnly: true,
                          controller: _dateTimeCtrl,
                        ),
                        SizedBox(height: 10.0),
                        TextFormCustom(
                          label: 'Aktivitas',
                          onChanged: (val) => _activityCtrl.text = val,
                          initialValue: _activityCtrl.text,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ButtonCustom(
                            child: !loading
                                ? Text(
                                    "Simpan",
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.white),
                                  )
                                : SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                            onPressed: !loading
                                ? () {
                                    dismissKeyboard(context);
                                    DateTime tempDate =
                                        new DateFormat("yyyy-MM-dd")
                                            .parse(_dateTimeCtrl!.text);
                                    setState(() {
                                      loading = true;
                                    });
                                    FirestoreDatabase(uid: user.uid)
                                        .updateEvent(
                                            KalenderModel(
                                                uid: user.uid,
                                                activity: _activityCtrl.text,
                                                date: tempDate
                                                    .add(Duration(hours: 6))),
                                            widget.docID)
                                        .then((value) {
                                          snackbarCustom('Data berhasil diubah')
                                              .show(context);
                                          Navigator.pop(context);
                                        })
                                        .catchError((onError) => snackbarCustom(
                                                'Terjadi kesalahan: $onError')
                                            .show(context))
                                        .whenComplete(() => setState(() {
                                              loading = false;
                                            }));
                                  }
                                : null),
                      ]),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
