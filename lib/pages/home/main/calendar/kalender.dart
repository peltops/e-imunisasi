import 'dart:collection';
import 'dart:math';

import 'package:eimunisasi/pages/home/main/calendar/add_event.dart';
import 'package:eimunisasi/pages/home/main/calendar/update_event.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:intl/intl.dart';
import 'package:eimunisasi/models/calendar.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:eimunisasi/services/calendar_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class KalenderPage extends StatefulWidget {
  @override
  _KalenderPageState createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  confirmDeleteDialog(BuildContext context, dynamic event) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {},
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

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  LinkedHashMap<DateTime, List<Calendars>> _groupedEvents;
  List<dynamic> _selectedEvents;
  final kFirstDay = DateTime(DateTime.now().year - 5);
  final kLastDay = DateTime(DateTime.now().year + 5);

  @override
  void initState() {
    _selectedEvents = [];
    _selectedDay = null;
    super.initState();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  _groupEvents(List<Calendars> allEvents) {
    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    allEvents.forEach((event) {
      DateTime date =
          DateTime.utc(event.date.year, event.date.month, event.date.day, 12);
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date].add(event);
    });
  }

  List<dynamic> _getEventsfromDay(DateTime date) {
    return _groupedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        elevation: 0.0,
        title: Text(
          "Kalender",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: SingleChildScrollView(
          child: StreamBuilder<List<Calendars>>(
              stream: FirestoreDatabase(uid: user.uid).calendarsStream,
              builder: (context, AsyncSnapshot<List<Calendars>> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }
                if (snapshot.hasData) {
                  final allEvents = snapshot.data;
                  _groupEvents(allEvents);
                  DateTime selectedDate = _selectedDay;
                  _selectedEvents = _groupedEvents[selectedDate] ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TableCalendar(
                        eventLoader: _getEventsfromDay,
                        headerStyle: HeaderStyle(
                            formatButtonVisible: false, titleCentered: true),
                        calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle),
                            selectedDecoration: BoxDecoration(
                                color: Colors.pink[200],
                                shape: BoxShape.circle)),
                        firstDay: kFirstDay,
                        lastDay: kLastDay,
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) {
                          return isSameDay(day, _selectedDay);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          // No need to call `setState()` here
                          _focusedDay = focusedDay;
                        },
                      ),
                      SizedBox(height: 30.0),
                      (selectedDate != null
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Daftar aktivitas : ' +
                                          DateFormat('dd MMMM yyyy')
                                              .format(selectedDate)
                                              .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration: Duration.zero,
                                              pageBuilder: (_, __, ___) =>
                                                  KalenderPage(),
                                            ),
                                          );

                                          setState(() {
                                            selectedDate = null;
                                          });
                                        },
                                        icon: Icon(Icons.close))
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                ..._selectedEvents.map((event) => ListTile(
                                      title: Text(event.activity),
                                      subtitle: Text(DateFormat('dd-MM-yyyy')
                                          .format(event.date)
                                          .toString()),
                                    )),
                              ],
                            )
                          : Container()),
                      SizedBox(
                          width: double.infinity,
                          child: (selectedDate == null
                              ? DataTable(
                                  headingTextStyle: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  dataTextStyle: TextStyle(
                                    fontFamily: 'Nunito',
                                    color: Colors.black,
                                  ),
                                  headingRowColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context).primaryColor),
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'Tanggal',
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Aktivitas',
                                      ),
                                    ),
                                  ],
                                  rows: allEvents
                                      .map(
                                        (e) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              Text(DateFormat('dd-MM-yyyy')
                                                  .format(e.date)
                                                  .toString()),
                                            ),
                                            DataCell(Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    e.activity,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                PopupMenuButton(
                                                  onSelected: (item) =>
                                                      selectedItem(
                                                          context,
                                                          item,
                                                          e.documentID,
                                                          e),
                                                  initialValue: 2,
                                                  child: Icon(
                                                    Icons.menu_outlined,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem<int>(
                                                        value: 0,
                                                        child: Text("Ubah")),
                                                    PopupMenuItem<int>(
                                                        value: 1,
                                                        child: Text("Hapus")),
                                                  ],
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      )
                                      .toList())
                              : null))
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddEventCalendar())),
      ),
    );
  }

  void selectedItem(BuildContext context, item, docID, Calendars data) {
    switch (item) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UpdateEventCalendar(
                  docID: docID,
                  data: data,
                )));
        break;
      case 1:
        try {
          FirestoreDatabase(uid: data.uid).deleteEvent(docID);
          snackbarCustom('Data berhasil dihapus').show(context);
        } catch (e) {
          snackbarCustom(e.toString()).show(context);
        }
        break;
    }
  }
}
