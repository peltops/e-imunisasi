import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/features/calendar/data/models/hive_calendar_activity_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarModel {
  final String? uid;
  final DateTime? date;
  final String? activity;
  final String? documentID;
  final bool? readOnly;

  CalendarModel({
    this.uid,
    this.activity,
    this.date,
    this.documentID,
    this.readOnly = false,
  });

  CalendarModel copyWith({
    String? uid,
    String? activity,
    DateTime? date,
    String? documentID,
    bool? readOnly,
  }) {
    return CalendarModel(
      uid: uid ?? this.uid,
      activity: activity ?? this.activity,
      date: date ?? this.date,
      documentID: documentID ?? this.documentID,
      readOnly: readOnly ?? this.readOnly,
    );
  }

  factory CalendarModel.fromMap(Map<String, dynamic>? data) {
    return CalendarModel(
      uid: data?['uid'] ?? emptyString,
      activity: data?['activity'] ?? emptyString,
      date: () {
        if (data?['date'] == null) return null;
        try {
          if (data?['date'] is DateTime) {
            return data?['date'];
          } else {
            return (data?['date'] as Timestamp).toDate();
          }
        } catch (e) {
          return null;
        }
      }(),
      readOnly: data?['readOnly'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "activity": activity,
      "date": date,
      "readOnly": readOnly,
    };
  }

  CalendarActivityHive toHive() {
    return CalendarActivityHive()
      ..activity = activity
      ..date = date;
  }
}

extension CalendarModelExtension on List<CalendarModel> {
  LinkedHashMap<DateTime, List<CalendarModel>> groupEventsByDate() {
    int getHashCode(DateTime key) {
      return key.day * 1000000 + key.month * 10000 + key.year;
    }

    var _groupedEvents = LinkedHashMap<DateTime, List<CalendarModel>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    this.forEach((event) {
      if (event.date == null) return;
      final date = DateTime.utc(
        event.date!.year,
        event.date!.month,
        event.date!.day,
        12,
      );
      if (_groupedEvents[date] == null) _groupedEvents[date] = [];
      _groupedEvents[date]?.add(event);
    });
    return _groupedEvents;
  }
}
