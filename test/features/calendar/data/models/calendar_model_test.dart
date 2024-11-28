import 'dart:collection';

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
      final result = testCalendarModel.toSeribase();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['parent_id'], equals('testUid'));
      expect(result['activity'], equals('testActivity'));
      expect(
          result['do_at'], equals(testCalendarModel.date?.toIso8601String()));
      expect(result['read_only'], equals(false));
    });

    test('should correctly create from a Map, date is DateTime', () {
      final createdDate = DateTime.now();
      final Map<String, dynamic> data = {
        'id': 'testID',
        'parent_id': 'testUid',
        'activity': 'testActivity',
        'do_at': testCalendarModel.date?.toIso8601String(),
        'read_only': false,
        'created_at': createdDate.toIso8601String(),
      };

      final result = CalendarModel.fromSeribase(data);

      expect(result, isA<CalendarModel>());
      expect(result.uid, equals('testUid'));
      expect(result.activity, equals('testActivity'));
      expect(result.date, equals(testCalendarModel.date));
      expect(result.readOnly, equals(false));
      expect(result.documentID, equals('testID'));
      expect(result.createdDate, equals(createdDate));
    });

    test('should correctly create from a Map, date is Null', () {
      final Map<String, dynamic> data = {
        'id': 'testID',
        'parent_id': 'testUid',
        'activity': 'testActivity',
        'read_only': false,
      };

      final result = CalendarModel.fromSeribase(data);

      expect(result, isA<CalendarModel>());
      expect(result.uid, equals('testUid'));
      expect(result.activity, equals('testActivity'));
      expect(result.date, equals(null));
      expect(result.readOnly, equals(false));
      expect(result.documentID, equals('testID'));
    });

    test('copy object with copyWith function', () {
      final result = testCalendarModel.copyWith(
        uid: 'testUid2',
        activity: 'testActivity2',
        date: DateTime.now().add(Duration(days: 1)),
        readOnly: true,
        documentID: 'testDocumentID2',
      );

      expect(result, isA<CalendarModel>());
      expect(result.uid, equals('testUid2'));
      expect(result.activity, equals('testActivity2'));
      expect(result.date, isNot(equals(testCalendarModel.date)));
      expect(result.readOnly, equals(true));
      expect(result.documentID, equals('testDocumentID2'));
    });

    test('copy object with copyWith function noChange values', () {
      final result = testCalendarModel.copyWith();

      expect(result, isA<CalendarModel>());
      expect(result, equals(testCalendarModel));
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

  group('test props compare', () {
    final testCalendarModel = CalendarModel(
      uid: 'testUid',
      activity: 'testActivity',
      date: DateTime.now(),
      readOnly: false,
      documentID: 'testDocumentID',
    );

    test('should return true when compare same object', () {
      final result = testCalendarModel == testCalendarModel;
      expect(result, equals(true));
    });

    test('should return false when compare different object', () {
      final result = testCalendarModel ==
          CalendarModel(
            uid: 'testUid2',
            activity: 'testActivity',
            date: DateTime.now(),
            readOnly: false,
            documentID: 'testDocumentID',
          );
      expect(result, equals(false));
    });
  });

  group('vaccinationSchedules', () {
    test('generate list calendar schedules from vaccinationSchedules function',
        () {
      final result = CalendarModel.vaccinationSchedules(
          'testUid', DateTime(2024, 1, 1), 'childName');
      expect(result, isA<List<CalendarModel>>());
      expect(result.length, equals(33));

      expect(result[0].activity, equals('Hepatitis B (childName)'));
      expect(result[0].date, equals(DateTime(2024, 3, 1, 6)));
      expect(result[0].readOnly, equals(true));
    });
  });
}
