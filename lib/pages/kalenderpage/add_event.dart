import 'package:e_imunisasi/models/user.dart';
import 'package:e_imunisasi/pages/profilepage/widget/textdecoration.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();
    _eventDate = DateTime.now();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          "Tambah event kalender",
          style: TextStyle(color: Colors.black),
        ),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter title" : null,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  decoration: textDecoration.copyWith(
                    labelText: 'Title',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter description" : null,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  decoration: textDecoration.copyWith(
                    labelText: 'Description',
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: Text("Date (YYYY-MM-DD)"),
                subtitle: Text(
                    "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                onTap: () async {
                  DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: _eventDate,
                      firstDate: DateTime(_eventDate.year - 5),
                      lastDate: DateTime(_eventDate.year + 5));
                  if (picked != null) {
                    setState(() {
                      _eventDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(4, 2),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xfffbb448),
                                    Color(0xfff7892b)
                                  ])),
                          child: FlatButton(
                            onPressed: !processing
                                ? () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        processing = true;
                                      });
                                      final DataKalender product = DataKalender(
                                          id: user.uid,
                                          title: _title.text,
                                          description: _description.text,
                                          eventDate: _eventDate);
                                      await DatabaseService(uid: user.uid)
                                          .addEventKalender(product.toMap());
                                      Navigator.pop(context);
                                      setState(() {
                                        processing = false;
                                      });
                                    }
                                  }
                                : null,
                            child: !processing
                                ? Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                          )),
                    ),
              // Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //     child: Material(
              //       elevation: 5.0,
              //       borderRadius: BorderRadius.circular(30.0),
              //       color: Theme.of(context).primaryColor,
              //       child: MaterialButton(
              //         onPressed: () async {
              //           if (_formKey.currentState.validate()) {
              //             setState(() {
              //               processing = true;
              //             });
              //             final DataKalender product = DataKalender(
              //                 id: user.uid,
              //                 title: _title.text,
              //                 description: _description.text,
              //                 eventDate: _eventDate);
              //             await DatabaseService(uid: user.uid)
              //                 .addEventKalender(product.toMap());
              //             Navigator.pop(context);
              //             setState(() {
              //               processing = false;
              //             });
              //           }
              //         },
              //         child: Text(
              //           "Save",
              //           style: style.copyWith(
              //               color: Colors.white,
              //               fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
