import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/models/calendar.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/calendar_database.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_signin_button/flutter_signin_button.dart';

class AddEventCalendar extends StatefulWidget {
  @override
  _AddEventCalendarState createState() => _AddEventCalendarState();
}

class _AddEventCalendarState extends State<AddEventCalendar> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateTimeCtrl = TextEditingController();
  TextEditingController _activityCtrl = TextEditingController();

  bool loading = false;
  final kFirstDay = DateTime(DateTime.now().year - 1);
  final kLastDay = DateTime(DateTime.now().year + 1);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Aktivitas'),
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
                        child: Column(children: [
                          SizedBox(height: 5.0),
                          TextFormCustom(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  theme: DatePickerTheme(
                                    doneStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                                  _dateTimeCtrl.text = formattedDate.toString();
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.id);
                            },
                            label: 'Tanggal',
                            readOnly: true,
                            controller: _dateTimeCtrl,
                          ),
                          SizedBox(height: 10.0),
                          TextFormCustom(
                            label: 'Aktivitas',
                            controller: _activityCtrl,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ButtonCustom(
                              child: !loading
                                  ? Text(
                                      AppConstant.SAVE,
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    )
                                  : SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                              onPressed: !loading
                                  ? () {
                                      dismissKeyboard(context);
                                      DateTime tempDate =
                                          new DateFormat("yyyy-MM-dd")
                                              .parse(_dateTimeCtrl.text);
                                      setState(() {
                                        loading = true;
                                      });
                                      FirestoreDatabase(uid: user.uid)
                                          .setEvent(KalenderModel(
                                              uid: user.uid,
                                              activity: _activityCtrl.text,
                                              date: tempDate
                                                  .add(Duration(hours: 6))))
                                          .then((value) {
                                            snackbarCustom(
                                                    'Data berhasil ditambah')
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
