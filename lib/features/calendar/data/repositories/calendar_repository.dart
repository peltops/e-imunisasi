import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/features/calendar/data/models/hive_calendar_activity_model.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CalendarRepository {
  final FirebaseFirestore firestore;
  final HiveInterface hiveInterface;

  CalendarRepository(
    this.firestore,
    this.hiveInterface,
  );

  Future<CalendarModel> setEvent(CalendarModel model) async {
    try {
      final result = await firestore.collection('calendars').add(model.toMap());
      return model.copyWith(documentID: result.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<CalendarModel> updateEvent(CalendarModel data) async {
    try {
      await firestore
          .collection('calendars')
          .doc(data.documentID)
          .update(data.toMap());
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEvent(String docID) async {
    try {
      await firestore.collection('calendars').doc(docID).delete();
    } on FirebaseException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CalendarModel>> getEvents() async {
    try {
      var snapshot =
          await firestore.collection('calendars').orderBy('date').get();
      return snapshot.docs.map((e) {
        var data = Map<String, dynamic>.from(e.data());
        return CalendarModel.fromMap(data).copyWith(documentID: e.id);
      }).toList();
    } on FirebaseException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> setEventLocal(CalendarActivityHive data) async {
    final box = await hiveInterface.openBox<CalendarActivityHive>('calendar_activity');
    return box.add(data);
  }

  Future<List<CalendarActivityHive>> getEventLocal() async {
    final box = await hiveInterface.openBox<CalendarActivityHive>('calendar_activity');
    return box.values.toList();
  }

  Future<void> updateEventLocal(CalendarActivityHive data) async {
    final box = await hiveInterface.openBox<CalendarActivityHive>('calendar_activity');
    return box.putAt(box.values.toList().indexWhere((element) => element.date == data.date), data);
  }

  Future<void> deleteEventLocal(CalendarActivityHive data) async {
    final box = await hiveInterface.openBox<CalendarActivityHive>('calendar_activity');
    return box.deleteAt(box.values.toList().indexWhere((element) => element.date == data.date));
  }

  Future<int> deleteAllEventLocal() async {
    final box = await hiveInterface.openBox<CalendarActivityHive>('calendar_activity');
    return await box.clear();
  }
}
