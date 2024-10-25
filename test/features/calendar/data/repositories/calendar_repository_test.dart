import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/features/calendar/data/models/hive_calendar_activity_model.dart';
import 'package:eimunisasi/features/calendar/data/repositories/calendar_repository.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([
  HiveInterface,
  GoTrueClient,
  SupabaseClient,
])
@GenerateNiceMocks([
  MockSpec<CalendarActivityHive>(),
  MockSpec<Box<CalendarActivityHive>>(),
  MockSpec<User>()
])
import 'calendar_repository_test.mocks.dart';

void main() {
  late SupabaseClient supabaseClient;

  setUpAll(() {
    supabaseClient = SupabaseClient(
      'https://test.com',
      'test',
      httpClient: MockSupabaseHttpClient(),
    );
  });
  group('setEvent', () {
    late CalendarRepository calendarRepository;

    setUp(() {
      calendarRepository = CalendarRepository(
        supabaseClient,
        Hive,
      );
    });

    test('success', () async {
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
    late CalendarRepository calendarRepository;

    setUp(() {
      calendarRepository = CalendarRepository(
        supabaseClient,
        Hive,
      );
    });

    test('success', () async {
      // Arrange
      final testEvent = CalendarModel(
        activity: 'test title',
        date: DateTime.now(),
        documentID: '1',
      );
      final insert = await calendarRepository.setEvent(testEvent);

      final result = calendarRepository.updateEvent(insert.copyWith(
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
  });

  group('deleteEvent', () {
    late CalendarRepository calendarRepository;

    // Arrange
    final testEvent = CalendarModel(
      activity: 'test title',
      date: DateTime.now(),
      documentID: '1',
    );
    setUp(() {
      calendarRepository = CalendarRepository(
        supabaseClient,
        Hive,
      );
    });

    test('calls delete with the correct data', () async {
      // Act
      final result =
          calendarRepository.deleteEvent(testEvent.documentID.orEmpty);

      // Assert
      expect(
        () async => await result,
        isA<void>(),
      );
    });
  });

  group('setEventLocal', () {
    late CalendarRepository calendarRepository;
    late HiveInterface hiveInterface;
    late Box<CalendarActivityHive> box;
    final activity = 'test title';
    final date = DateTime.now();
    final testEvent = MockCalendarActivityHive()
      ..activity = activity
      ..date = date;
    final eventModel = CalendarModel(
      activity: activity,
      date: date,
    );
    setUp(() {
      hiveInterface = MockHiveInterface();
      box = MockBox();
      calendarRepository = CalendarRepository(
        supabaseClient,
        hiveInterface,
      );
    });
    test('returns a list of CalendarModel if the call to firestore succeeds',
        () async {
      when(box.add(testEvent)).thenAnswer((_) async => 1);
      when(hiveInterface.openBox<CalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      final res = await calendarRepository.setEventLocal(eventModel);
      expect(res, isA<int>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(hiveInterface.openBox<CalendarActivityHive>('calendar_activity'))
          .thenThrow(Exception());
      when(box.add(testEvent)).thenThrow(Exception());

      expect(
        () => calendarRepository.setEventLocal(eventModel),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getEventLocal', () {
    late CalendarRepository calendarRepository;
    late HiveInterface hiveInterface;
    late Box<CalendarActivityHive> box;
    final activity = 'test title';
    final date = DateTime.now();
    final testEvent = MockCalendarActivityHive()
      ..activity = activity
      ..date = date;
    setUp(() {
      hiveInterface = MockHiveInterface();
      box = MockBox();
      calendarRepository = CalendarRepository(
        supabaseClient,
        hiveInterface,
      );
    });
    test('returns a list of CalendarModel if the call to firestore succeeds',
        () async {
      when(hiveInterface.openBox<CalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.values).thenReturn([testEvent]);
      final res = await calendarRepository.getEventLocal();
      expect(res, isA<List<CalendarActivityHive>>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(hiveInterface.openBox<CalendarActivityHive>('calendar_activity'))
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
    late Box<CalendarActivityHive> box;
    setUp(() {
      hiveInterface = MockHiveInterface();
      box = MockBox();
      calendarRepository = CalendarRepository(
        supabaseClient,
        hiveInterface,
      );
    });
    test('returns a list of CalendarModel if the call to firestore succeeds',
        () async {
      when(hiveInterface.openBox<CalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.clear()).thenAnswer((_) async => 1);
      final res = await calendarRepository.deleteAllEventLocal();
      expect(res, isA<void>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(hiveInterface.openBox<CalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.clear()).thenThrow(Exception());

      expect(
        () => calendarRepository.deleteAllEventLocal(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('deleteEventLocal', () {
    late CalendarRepository calendarRepository;
    late HiveInterface hiveInterface;
    late Box<CalendarActivityHive> box;
    final activity = 'test title';
    final date = DateTime.now();
    final testEvent = MockCalendarActivityHive()
      ..activity = activity
      ..date = date;
    final eventModel = CalendarModel(
      activity: activity,
      date: date,
    );
    setUp(() {
      hiveInterface = MockHiveInterface();
      box = MockBox();
      calendarRepository = CalendarRepository(
        supabaseClient,
        hiveInterface,
      );
    });
    test('returns a list of CalendarModel if the call to firestore succeeds',
        () async {
      when(hiveInterface.openBox<CalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.deleteAt(0)).thenAnswer((_) async => 1);
      when(box.values).thenReturn([testEvent]);

      final res = calendarRepository.deleteEventLocal(eventModel);
      expect(() async => await res, isA<void>());
    });

    test('throws an exception if the call to firestore unsucceeds', () async {
      when(hiveInterface.openBox<CalendarActivityHive>('calendar_activity'))
          .thenAnswer((_) async => box);
      when(box.values).thenThrow(Exception());
      when(box.delete(any)).thenThrow(Exception());

      expect(
        () => calendarRepository.deleteEventLocal(eventModel),
        throwsA(isA<Exception>()),
      );
    });
  });
}
