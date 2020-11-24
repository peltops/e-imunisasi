import 'package:e_imunisasi/models/user.dart';
import 'package:e_imunisasi/pages/profilepage/widget/textdecoration.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bird extends StatefulWidget {
  const Bird({
    Key key,
    this.color = const Color(0xFFFFE306),
    this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  _BirdState createState() => _BirdState();
}

class _BirdState extends State<Bird> {
  double _size = 1.0;

  void grow() {
    setState(() {
      _size += 0.1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      transform: Matrix4.diagonal3Values(_size, _size, 1.0),
      child: widget.child,
    );
  }
}

class EventDetailsPage extends StatefulWidget {
  final DataKalender event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String judul;
  String deskripsi;

  bool _edit = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Note details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _edit = !_edit;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: widget.event.title,
                enabled: _edit,
                decoration: textDecoration.copyWith(
                  labelText: 'Judul agenda',
                ),
                validator: (val) =>
                    val.length == 0 ? 'Masukan judul agenda' : null,
                onChanged: (val) {
                  judul = val;
                },
              ),
              TextFormField(
                initialValue: widget.event.description,
                enabled: _edit,
                decoration: textDecoration.copyWith(
                  labelText: 'Deskripsi',
                ),
                validator: (val) =>
                    val.length == 0 ? 'Masukan deskripsi agenda' : null,
                onChanged: (val) {
                  deskripsi = val;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
                        colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                child: _edit
                    ? FlatButton(
                        onPressed: !loading
                            ? () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  await DatabaseService(uid: user.uid)
                                      .updateEventKalender(
                                          DataKalender(
                                            title: judul ?? widget.event.title,
                                            description: deskripsi ??
                                                widget.event.description,
                                            eventDate: widget.event.eventDate,
                                            id: widget.event.id,
                                          ).toMap(),
                                          widget.event.documentID);

                                  Navigator.pop(context);
                                }
                              }
                            : null,
                        child: !loading
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
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
