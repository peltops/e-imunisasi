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
  final DateTime? createdDate;

  CalendarModel({
    this.uid,
    this.activity,
    this.date,
    this.documentID,
    this.readOnly = false,
    this.createdDate,
  });

  static String tableName = 'calendars';

  CalendarModel copyWith({
    String? uid,
    String? activity,
    DateTime? date,
    String? documentID,
    bool? readOnly,
    DateTime? createdDate,
  }) {
    return CalendarModel(
      uid: uid ?? this.uid,
      activity: activity ?? this.activity,
      date: date ?? this.date,
      documentID: documentID ?? this.documentID,
      readOnly: readOnly ?? this.readOnly,
      createdDate: createdDate ?? this.createdDate,
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
      createdDate: () {
        if (data?['createdDate'] == null) return null;
        try {
          if (data?['createdDate'] is DateTime) {
            return data?['createdDate'];
          } else {
            return (data?['createdDate'] as Timestamp).toDate();
          }
        } catch (e) {
          return null;
        }
      }(),
    );
  }

  factory CalendarModel.fromSeribase(Map<String, dynamic>? data) {
    return CalendarModel(
      uid: data?['parent_id'] ?? emptyString,
      activity: data?['activity'] ?? emptyString,
      date: () {
        if (data?['do_at'] == null) return null;
        try {
          return DateTime.parse(data?['do_at']);
        } catch (e) {
          return null;
        }
      }(),
      readOnly: data?['read_only'] ?? false,
      createdDate: () {
        if (data?['created_at'] == null) return null;
        try {
          return DateTime.parse(data?['created_at']);
        } catch (e) {
          return null;
        }
      }(),
      documentID: data?['id'] ?? emptyString,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "activity": activity,
      "date": date,
      "readOnly": readOnly,
      "createdDate": createdDate ?? DateTime.now(),
    };
  }

  Map<String, dynamic> toSeribase() {
    return {
      "id": documentID,
      "parent_id": uid,
      "activity": activity,
      "do_at": date?.toIso8601String(),
      "read_only": readOnly,
      "created_at": (createdDate ?? DateTime.now()).toIso8601String(),
    };
  }

  CalendarActivityHive toHive() {
    return CalendarActivityHive()
      ..activity = activity
      ..id = createdDate?.millisecondsSinceEpoch
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
