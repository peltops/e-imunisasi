import 'dart:collection';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/models/hive_calendar_activity.dart';
import 'package:eimunisasi/pages/home/utama/kalender/add_event.dart';
import 'package:eimunisasi/pages/home/utama/kalender/update_event.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/services/notifications.dart';
import 'package:hive/hive.dart';
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
  List<KalenderModel>? allEvents;
  confirmDeleteDialog(BuildContext context, dynamic event) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(AppConstant.NO),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(AppConstant.YES),
      onPressed: () async {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppConstant.CONFIRMATION),
      content: Text(AppConstant.DELETE_CONFIRMATION_QUESTION),
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
  DateTime _onPageChangeDate = DateTime.now();
  DateTime? _selectedDay;
  late LinkedHashMap<DateTime, List<KalenderModel>> _groupedEvents;
  late List<dynamic> _selectedEvents;
  final kFirstDay = DateTime(DateTime.now().year - 5);
  final kLastDay = DateTime(DateTime.now().year + 5);

  @override
  void initState() {
    NotificationService().cancelNotificationAll();
    Hive.box<CalendarsHive>('calendar_activity')
        .deleteAll(Hive.box<CalendarsHive>('calendar_activity').keys);
    _selectedEvents = [];
    _selectedDay = null;
    super.initState();
  }

  @override
  void dispose() {
    allEvents!.asMap().forEach((i, v) {
      addActivityHive(activity: v.activity, date: v.date);
    });
    // Hive.close();
    super.dispose();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  _groupEvents(List<KalenderModel> allEvents) {
    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    allEvents.forEach((event) {
      DateTime date = DateTime.utc(
          event.date!.year, event.date!.month, event.date!.day, 12);
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date]!.add(event);
    });
  }

  List<dynamic> _getEventsfromDay(DateTime date) {
    return _groupedEvents[date] ?? [];
  }

  CalendarBuilders calendarBuilder() {
    return CalendarBuilders(markerBuilder: (context, date, events) {
      if (events.isNotEmpty) {
        return Positioned(
          bottom: 1,
          child: Container(
            padding: EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(minWidth: 15.0, minHeight: 15.0),
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
        );
      }
      return Container();
    });
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
          AppConstant.CALENDAR_LABEL,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddEventCalendar())))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: StreamBuilder<List<KalenderModel>>(
              stream: FirestoreDatabase(uid: user.uid).calendarsStream,
              builder: (context, AsyncSnapshot<List<KalenderModel>> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error'));
                }
                if (snapshot.hasData) {
                  allEvents = snapshot.data;
                  _groupEvents(allEvents!);

                  DateTime? selectedDate = _selectedDay;
                  _selectedEvents = _groupedEvents[selectedDate!] ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TableCalendar(
                        calendarBuilders: calendarBuilder(),
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
                          setState(() {
                            _onPageChangeDate = focusedDay;
                          });
                        },
                      ),
                      SizedBox(height: 30.0),
                      (_selectedDay != null
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
                                    CircleAvatar(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _selectedDay = null;
                                            });
                                          },
                                          icon: Icon(Icons.close_rounded)),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.0),
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
                                  headingRowHeight: 40,
                                  // dataRowHeight: DataRowHeight.flexible(),
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
                                  rows: allEvents!
                                      .where((e) =>
                                          e.date!.month ==
                                              _onPageChangeDate.month &&
                                          e.date!.year ==
                                              _onPageChangeDate.year)
                                      .map(
                                        (e) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              Text(DateFormat('dd-MM-yyyy')
                                                  .format(e.date!)
                                                  .toString()),
                                            ),
                                            DataCell(Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    e.activity!,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                !e.readOnly!
                                                    ? PopupMenuButton(
                                                        onSelected: (dynamic
                                                                item) =>
                                                            selectedItem(
                                                                context,
                                                                item,
                                                                e.documentID,
                                                                e),
                                                        initialValue: 2,
                                                        child: Icon(
                                                          Icons.more_vert,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        itemBuilder:
                                                            (context) => [
                                                          PopupMenuItem<int>(
                                                              value: 0,
                                                              child: Text(
                                                                  AppConstant
                                                                      .EDIT)),
                                                          PopupMenuItem<int>(
                                                              value: 1,
                                                              child: Text(
                                                                  AppConstant
                                                                      .DELETE)),
                                                        ],
                                                      )
                                                    : Container(),
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
    );
  }

  Future addActivityHive({required String? activity, required DateTime? date}) {
    final calendarsActivity = CalendarsHive()
      ..activity = activity
      ..date = date;
    return Hive.box<CalendarsHive>('calendar_activity').add(calendarsActivity);
  }

  void selectedItem(BuildContext context, item, docID, KalenderModel data) {
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
