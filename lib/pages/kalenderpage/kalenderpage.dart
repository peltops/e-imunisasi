import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_imunisasi/models/user.dart';
import 'package:e_imunisasi/pages/widget/cardName.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_event.dart';
import 'view_event.dart';
import 'package:table_calendar/table_calendar.dart';

class KalenderPage extends StatefulWidget {
  @override
  _KalenderPageState createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  confirmDeleteDialog(BuildContext context, dynamic event) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        await Firestore.instance
            .collection('KalenderData')
            .document(event.documentID)
            .delete();
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Apakah anda yakin akan menghapus ${event.title}?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<DataKalender> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Kalender",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<List<DataKalender>>(
          stream: DatabaseService().eventKalender,
          builder: (BuildContext context,
              AsyncSnapshot<List<DataKalender>> snapshot) {
            if (snapshot.hasData) {
              List<DataKalender> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _events = _groupEvents(allEvents);
              } else {
                _events = {};
                _selectedEvents = [];
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CardName(),
                    TableCalendar(
                      events: _events,
                      initialCalendarFormat: CalendarFormat.month,
                      calendarStyle: CalendarStyle(
                          canEventMarkersOverflow: true,
                          todayColor: Theme.of(context).primaryColor,
                          selectedColor: Colors.grey,
                          todayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white)),
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        formatButtonVisible: false,
                      ),
                      onDaySelected: (date, events, _) {
                        setState(() {
                          _selectedEvents = events;
                        });
                      },
                      builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) =>
                            Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                        todayDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                        markersBuilder: (context, date, events, holidays) {
                          final children = <Widget>[];
                          if (events.isNotEmpty) {
                            children.add(
                              Positioned(
                                bottom: 1,
                                child: Container(
                                  padding: EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                      color: Colors.red[800],
                                      shape: BoxShape.circle),
                                  constraints: BoxConstraints(
                                      minWidth: 15.0, minHeight: 15.0),
                                  child: Center(
                                    child: Text(
                                      "${events.length}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return children;
                        },
                      ),
                      calendarController: _controller,
                    ),
                    SizedBox(height: 10.0),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Event List",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    SizedBox(height: 10.0),
                    ..._selectedEvents.map((event) => Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: Colors.deepOrange[100],
                          elevation: 2.0,
                          child: ListTile(
                            title: Text(event.title),
                            trailing: IconButton(
                                icon: Icon(Icons.delete_forever),
                                color: Colors.red,
                                onPressed: () {
                                  confirmDeleteDialog(context, event);
                                }),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EventDetailsPage(
                                            event: event,
                                          )));
                            },
                          ),
                        )),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: StreamBuilder<TypeUser>(
          stream: DatabaseService(uid: user.uid).typeUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TypeUser typeUser = snapshot.data;
              return typeUser.typeUser == 'medisCollection'
                  ? FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEventPage())),
                    )
                  : Container();
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
