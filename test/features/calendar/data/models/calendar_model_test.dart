import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/features/calendar/data/models/hive_calendar_activity_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarModel', () {
    final testCalendarModel = CalendarModel(
      uid: 'testUid',
      activity: 'testActivity',
      date: DateTime.now(),
      readOnly: false,
      documentID: 'testDocumentID',
    );

    test('should correctly convert to a Map', () {
      final result = testCalendarModel.toMap();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['uid'], equals('testUid'));
      expect(result['activity'], equals('testActivity'));
      expect(result['date'], equals(testCalendarModel.date));
      expect(result['readOnly'], equals(false));
    });

    test('should correctly create from a Map, date is Timestamp', () {
      final Map<String, dynamic> data = {
        'uid': 'testUid',
        'activity': 'testActivity',
        'date': Timestamp.fromDate(testCalendarModel.date!),
        'readOnly': false,
      };
      final id = 'testDocumentID';

      final result = CalendarModel.fromMap(data).copyWith(
        documentID: id,
      );

      expect(result, isA<CalendarModel>());
      expect(result.uid, equals('testUid'));
      expect(result.activity, equals('testActivity'));
      expect(result.date, equals(testCalendarModel.date));
      expect(result.readOnly, equals(false));
      expect(result.documentID, equals('testDocumentID'));
    });

    test('should correctly create from a Map, date is DateTime', () {
      final Map<String, dynamic> data = {
        'uid': 'testUid',
        'activity': 'testActivity',
        'date': testCalendarModel.date,
        'readOnly': false,
      };
      final id = 'testDocumentID';

      final result = CalendarModel.fromMap(data).copyWith(
        documentID: id,
      );

      expect(result, isA<CalendarModel>());
      expect(result.uid, equals('testUid'));
      expect(result.activity, equals('testActivity'));
      expect(result.date, equals(testCalendarModel.date));
      expect(result.readOnly, equals(false));
      expect(result.documentID, equals('testDocumentID'));
    });

    test('should correctly create from a Map, date is Null', () {
      final Map<String, dynamic> data = {
        'uid': 'testUid',
        'activity': 'testActivity',
        'readOnly': false,
      };
      final id = 'testDocumentID';

      final result = CalendarModel.fromMap(data).copyWith(
        documentID: id,
      );

      expect(result, isA<CalendarModel>());
      expect(result.uid, equals('testUid'));
      expect(result.activity, equals('testActivity'));
      expect(result.date, equals(null));
      expect(result.readOnly, equals(false));
      expect(result.documentID, equals('testDocumentID'));
    });

    test('should correctly convert to a CalendarActivityHive', () {
      final result = testCalendarModel.toHive();

      expect(result, isA<CalendarActivityHive>());
      expect(result.activity, equals('testActivity'));
      expect(result.date, equals(testCalendarModel.date));
    });

    test('should correctly groupEventsByDate from a List<CalendarModel>', () {
      final date1 = DateTime.now();
      final date2 = DateTime.now().add(Duration(days: 1));
      final List<CalendarModel> data = [
        CalendarModel(
          uid: 'testUid',
          activity: 'testActivity',
          date: date1,
          readOnly: false,
          documentID: 'testDocumentID',
        ),
        CalendarModel(
          uid: 'testUid2',
          activity: 'testActivity2',
          date: date1,
          readOnly: false,
          documentID: 'testDocumentID2',
        ),
        CalendarModel(
          uid: 'testUid3',
          activity: 'testActivity3',
          date: date2,
          readOnly: false,
          documentID: 'testDocumentID3',
        ),
        CalendarModel(
          uid: 'testUid4',
          activity: 'testActivity4',
          date: date2,
          readOnly: false,
          documentID: 'testDocumentID4',
        )
      ];

      final result = data.groupEventsByDate();

      expect(result, isA<LinkedHashMap<DateTime, List<CalendarModel>>>());
      expect(result.length, equals(2));
      expect(result[date1], isA<List<CalendarModel>>());
      expect(result[date1]!.length, equals(2));
      expect(result[date1]![0].uid, equals('testUid'));
      expect(result[date1]![1].uid, equals('testUid2'));
      expect(result[date2], isA<List<CalendarModel>>());
      expect(result[date2]!.length, equals(2));
      expect(result[date2]![0].uid, equals('testUid3'));
      expect(result[date2]![1].uid, equals('testUid4'));
    });
  });
}