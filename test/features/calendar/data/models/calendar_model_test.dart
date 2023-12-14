import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
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
  });
}