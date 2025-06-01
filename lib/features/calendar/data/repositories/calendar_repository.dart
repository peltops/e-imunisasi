import 'package:eimunisasi/features/calendar/data/models/calendar_model.dart';
import 'package:eimunisasi/features/calendar/data/models/hive_calendar_activity_model.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable()
class CalendarRepository {
  final SupabaseClient supabase;
  final HiveInterface hiveInterface;

  CalendarRepository(
    this.supabase,
    this.hiveInterface,
  );

  Future<CalendarModel> setEvent(CalendarModel model) async {
    try {
      final modelWithCreatedDate = model.copyWith(createdDate: DateTime.now());
      final result = await supabase
          .from(CalendarModel.tableName)
          .insert(
            modelWithCreatedDate.toSeribase(),
          )
          .select('id');
      if (result.isEmpty) {
        throw Exception('Failed to create event');
      }
      return modelWithCreatedDate.copyWith(documentID: result.first['id']);
    } catch (e) {
      rethrow;
    }
  }

  Future<CalendarModel> updateEvent(CalendarModel data) async {
    try {
      assert(data.documentID != null, 'ID must not be null');
      await supabase
          .from(CalendarModel.tableName)
          .update(data.toSeribase())
          .eq('id', data.documentID!);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEvent(String docID) async {
    try {
      await supabase.from(CalendarModel.tableName).delete().eq(
            'id',
            docID,
          );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CalendarModel>> getEvents() async {
    try {
      final uid = supabase.auth.currentUser?.id;
      assert(uid != null, 'User ID must not be null');
      final result = await supabase
          .from(CalendarModel.tableName)
          .select()
          .eq('parent_id', uid!)
          .order('created_at', ascending: false)
          .withConverter(
            (json) => json.map((e) => CalendarModel.fromSeribase(e)).toList(),
          );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> setEventLocal(CalendarModel data) async {
    try {
      final box = await hiveInterface
          .openBox<CalendarActivityHive>('calendar_activity');
      final id = data.createdDate?.millisecondsSinceEpoch;
      await box.put('$id', data.toHive());
      return box.values.toList().indexWhere((element) => element.id == id);
    } catch (e) {
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
