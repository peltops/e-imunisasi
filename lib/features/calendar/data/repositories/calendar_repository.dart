import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/features/calendar/data/models/hive_calendar_activity_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CalendarRepository {
  final FirebaseFirestore firestore;
  final HiveInterface hiveInterface;
  final FirebaseAuth auth;

  CalendarRepository(
    this.firestore,
    this.hiveInterface,
    this.auth,
  );

  Future<CalendarModel> setEvent(CalendarModel model) async {
    try {
      final modelWithCreatedDate = model.copyWith(createdDate: DateTime.now());
      final result = await firestore.collection('calendars').add(
            modelWithCreatedDate.toMap(),
          );
      return modelWithCreatedDate.copyWith(documentID: result.id);
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
      final uid = auth.currentUser?.uid;
      var snapshot = await firestore
          .collection('calendars')
          .where('uid', isEqualTo: uid)
          .orderBy('date')
          .get();
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

  Future<int> setEventLocal(CalendarModel data) async {
    try {
      final box =
      await hiveInterface.openBox<CalendarActivityHive>('calendar_activity');
      final id = data.createdDate?.millisecondsSinceEpoch;
      await box.put('$id', data.toHive());
      return box.values.toList().indexWhere((element) => element.id == id);
    }catch (e) {
      rethrow;
    }
  }

  Future<List<CalendarActivityHive>> getEventLocal() async {
    final box =
        await hiveInterface.openBox<CalendarActivityHive>('calendar_activity');
    return box.values.toList();
  }

  Future<void> deleteEventLocal(CalendarModel data) async {
    final box =
        await hiveInterface.openBox<CalendarActivityHive>('calendar_activity');
    final id = data.createdDate?.millisecondsSinceEpoch;
    return box.delete('$id');
  }

  Future<int> deleteAllEventLocal() async {
    final box =
        await hiveInterface.openBox<CalendarActivityHive>('calendar_activity');
    return await box.clear();
  }
}
