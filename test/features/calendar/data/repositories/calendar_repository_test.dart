import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/features/calendar/data/models/hive_calendar_activity_model.dart';
import 'package:eimunisasi/features/calendar/data/repositories/calendar_repository.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  Query,
  QuerySnapshot,
  HiveInterface,
  Box,
], customMocks: [
  MockSpec<QueryDocumentSnapshot>(
    as: #MockQueryDocumentSnapshot,
    unsupportedMembers: {
      #data,
    },
  ),
])
@GenerateNiceMocks([
  MockSpec<CalendarActivityHive>(),
])
import 'calendar_repository_test.mocks.dart';

void main() {
  group('setEvent', () {
    late FirebaseFirestore mockFirebaseFirestore;
    late CalendarRepository calendarRepository;

    setUp(() {
      mockFirebaseFirestore = FakeFirebaseFirestore();
      calendarRepository = CalendarRepository(mockFirebaseFirestore, Hive);
    });

    test('calls add on a CollectionReference with the correct data', () async {
      // Arrange
      final testEvent = CalendarModel(
        activity: 'test title',
        date: DateTime.now(),
      );
      // Act
      final result = calendarRepository.setEvent(testEvent);
      final resultAwait = await result;
      // Assert
      expect(result, isA<Future<CalendarModel>>());
      expect(resultAwait, isA<CalendarModel>());
      expect(resultAwait.activity, testEvent.activity);
      expect(resultAwait.date, testEvent.date);
    });

    test('throws an exception when the call to Firestore fails', () async {
      /// According to the doc of fake_cloud_firestore : https://pub.dev/packages/fake_cloud_firestore
      /// support mocking exceptions:
      ///
      /// DocumentReference.get, set, update, delete.
      /// Query.get.
      /// So we can't mock the exception for CollectionReference.add
    });
  });

  group('updateEvent', () {
    late FirebaseFirestore mockFirebaseFirestore;
    late CalendarRepository calendarRepository;

    setUp(() {
      mockFirebaseFirestore = FakeFirebaseFirestore();
      calendarRepository = CalendarRepository(mockFirebaseFirestore, Hive);
    });

    test('calls update on a DocumentReference with the correct data', () async {
      // Arrange
      final testEvent = CalendarModel(
        activity: 'test title',
        date: DateTime.now(),
        documentID: '1',
      );
      // Act
      await mockFirebaseFirestore
          .collection('calendars')
          .doc(testEvent.documentID)
          .set(testEvent.toMap());
      final result = calendarRepository.updateEvent(testEvent.copyWith(
        activity: 'changed title',
      ));
      final resultAwait = await result;

      // Assert
      expect(result, isA<Future<CalendarModel>>());
      expect(resultAwait, isA<CalendarModel>());
      expect(resultAwait.activity, 'changed title');
      expect(resultAwait.date, testEvent.date);
      expect(resultAwait.documentID, testEvent.documentID);
    });

    test('throws an exception if the call to firestore failed', () async {
      // Arrange
      final testEvent = CalendarModel(
        activity: 'test title',
        date: DateTime.now(),
        documentID: '1',
      );
      final doc = mockFirebaseFirestore
          .collection('calendars')
          .doc(testEvent.documentID);
      whenCalling(Invocation.method(#update, [testEvent.toMap()]))
          .on(doc)
          .thenThrow(FirebaseException(plugin: 'firestore'));
      expect(
        () => calendarRepository.updateEvent(testEvent),
        throwsA(isA<FirebaseException>()),
      );
    });
  });

  group('deleteEvent', () {
    late FirebaseFirestore mockFirebaseFirestore;
    late CalendarRepository calendarRepository;
    // Arrange
    final testEvent = CalendarModel(
      activity: 'test title',
      date: DateTime.now(),
      documentID: '1',
    );
    setUp(() {
      mockFirebaseFirestore = FakeFirebaseFirestore();
      calendarRepository = CalendarRepository(mockFirebaseFirestore, Hive);
    });

    test('calls delete on a DocumentReference with the correct data', () async {
      // Act
      await mockFirebaseFirestore
          .collection('calendars')
          .doc(testEvent.documentID)
          .delete();
      final result =
          calendarRepository.deleteEvent(testEvent.documentID.orEmpty);

      // Assert
      expect(
        () async => await result,
        isA<void>(),
      );
    });
  });

  group('getEvents', () {
    late CalendarRepository calendarRepository;
    late FirebaseFirestore firestore;

    late CollectionReference<Map<String, dynamic>> collectionReference;
    late Query<Map<String, dynamic>> query;
    late QuerySnapshot<Map<String, dynamic>> querySnapshot;
    late QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot;
    late List<QueryDocumentSnapshot<Map<String, dynamic>>>
        listQueryDocumentSnapshot;

    // Arrange
    final testEvent = CalendarModel(
      activity: 'test title',
      date: DateTime.now(),
      documentID: '1',
    );

    setUp(() {
      firestore = MockFirebaseFirestore();
      collectionReference = MockCollectionReference();
      query = MockQuery();
      querySnapshot = MockQuerySnapshot();
      queryDocumentSnapshot = MockQueryDocumentSnapshot();
      listQueryDocumentSnapshot = [queryDocumentSnapshot];
      calendarRepository = CalendarRepository(
        firestore,
        Hive,
      );
    });
    test('returns a list of CalendarModel if the call to firestore succeeds',
        () async {
      when(
        firestore.collection('calendars'),
      ).thenAnswer((_) => collectionReference);
      when(collectionReference.orderBy('date')).thenReturn(query);
      when(query.get()).thenAnswer((_) async => querySnapshot);
      when(querySnapshot.docs).thenReturn(listQueryDocumentSnapshot);
      when(queryDocumentSnapshot.id).thenReturn(testEvent.documentID.orEmpty);
      when(queryDocumentSnapshot.data()).thenReturn(testEvent.toMap());
      final res = await calendarRepository.getEvents();
      expect(res, isA<List<CalendarModel>>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(
        firestore.collection('calendars'),
      ).thenAnswer((_) => collectionReference);
      when(collectionReference.orderBy('date')).thenReturn(query);
      when(query.get()).thenThrow(Exception());

      expect(() => calendarRepository.getEvents(), throwsA(isA<Exception>()));
    });
  });

  group('setEventLocal', () {
    late CalendarRepository calendarRepository;
    late HiveInterface hiveInterface;
    late Box<MockCalendarActivityHive> box;
    final activity = 'test title';
    final date = DateTime.now();
    final testEvent = MockCalendarActivityHive()
      ..activity = activity
      ..date = date;
    setUp(() {
      hiveInterface = MockHiveInterface();
      box = MockBox();
      calendarRepository = CalendarRepository(
        MockFirebaseFirestore(),
        hiveInterface,
      );
    });
    test('returns a list of CalendarModel if the call to firestore succeeds',
        () async {
      when(hiveInterface.openBox<MockCalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.add(testEvent)).thenAnswer((_) async => 1);
      final res = await calendarRepository.setEventLocal(testEvent);
      expect(res, isA<int>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(hiveInterface.openBox<MockCalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.add(testEvent)).thenThrow(Exception());

      expect(
        () => calendarRepository.setEventLocal(testEvent),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getEventLocal', () {
    late CalendarRepository calendarRepository;
    late HiveInterface hiveInterface;
    late Box<MockCalendarActivityHive> box;
    final activity = 'test title';
    final date = DateTime.now();
    final testEvent = MockCalendarActivityHive()
      ..activity = activity
      ..date = date;
    setUp(() {
      hiveInterface = MockHiveInterface();
      box = MockBox();
      calendarRepository = CalendarRepository(
        MockFirebaseFirestore(),
        hiveInterface,
      );
    });
    test('returns a list of CalendarModel if the call to firestore succeeds',
        () async {
      when(hiveInterface.openBox<MockCalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.values).thenReturn([testEvent]);
      final res = await calendarRepository.getEventLocal();
      expect(res, isA<List<MockCalendarActivityHive>>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(hiveInterface.openBox<MockCalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.values).thenThrow(Exception());

      expect(
        () => calendarRepository.getEventLocal(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('deleteAllEventLocal', () {
    late CalendarRepository calendarRepository;
    late HiveInterface hiveInterface;
    late Box<MockCalendarActivityHive> box;
    setUp(() {
      hiveInterface = MockHiveInterface();
      box = MockBox();
      calendarRepository = CalendarRepository(
        MockFirebaseFirestore(),
        hiveInterface,
      );
    });
    test('returns a list of CalendarModel if the call to firestore succeeds',
        () async {
      when(hiveInterface.openBox<MockCalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.clear()).thenAnswer((_) async => 1);
      final res = await calendarRepository.deleteAllEventLocal();
      expect(res, isA<void>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(hiveInterface.openBox<MockCalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.clear()).thenThrow(Exception());

      expect(
        () => calendarRepository.deleteAllEventLocal(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateEventLocal', () {
    late CalendarRepository calendarRepository;
    late HiveInterface hiveInterface;
    late Box<MockCalendarActivityHive> box;
    final activity = 'test title';
    final date = DateTime.now();
    final testEvent = MockCalendarActivityHive()
      ..activity = activity
      ..date = date;
    setUp(() {
      hiveInterface = MockHiveInterface();
      box = MockBox();
      calendarRepository = CalendarRepository(
        MockFirebaseFirestore(),
        hiveInterface,
      );
    });
    test('returns a list of CalendarModel if the call to firestore succeeds',
        () async {
      when(hiveInterface.openBox<MockCalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.putAt(0, testEvent)).thenAnswer((_) async => 1);
      when(box.values).thenReturn([testEvent]);

      final res = calendarRepository.updateEventLocal(testEvent);
      expect(() async => await res, isA<void>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(hiveInterface.openBox<MockCalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.values).thenThrow(Exception());
      when(box.putAt(0, testEvent)).thenThrow(Exception());

      expect(
        () => calendarRepository.updateEventLocal(testEvent),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('deleteEventLocal', () {
    late CalendarRepository calendarRepository;
    late HiveInterface hiveInterface;
    late Box<MockCalendarActivityHive> box;
    final activity = 'test title';
    final date = DateTime.now();
    final testEvent = MockCalendarActivityHive()
      ..activity = activity
      ..date = date;
    setUp(() {
      hiveInterface = MockHiveInterface();
      box = MockBox();
      calendarRepository = CalendarRepository(
        MockFirebaseFirestore(),
        hiveInterface,
      );
    });
    test('returns a list of CalendarModel if the call to firestore succeeds',
        () async {
      when(hiveInterface.openBox<MockCalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.deleteAt(0)).thenAnswer((_) async => 1);
      when(box.values).thenReturn([testEvent]);

      final res = calendarRepository.deleteEventLocal(testEvent);
      expect(() async => await res, isA<void>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(hiveInterface.openBox<MockCalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.values).thenThrow(Exception());
      when(box.deleteAt(0)).thenThrow(Exception());

      expect(
        () => calendarRepository.deleteEventLocal(testEvent),
        throwsA(isA<Exception>()),
      );
    });
  });
}
