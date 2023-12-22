import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CalendarRepository {
  final FirebaseFirestore firestore;

  CalendarRepository(
    this.firestore,
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
}
