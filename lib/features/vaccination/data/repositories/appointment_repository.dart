import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class AppointmentRepository {
  final SupabaseClient supabaseClient;

  AppointmentRepository(
    this.supabaseClient,
  );

  Future<List<AppointmentModel>> getAppointments({
    required String userId,
  }) async {
    try {
      final result = await supabaseClient
          .from(AppointmentModel.tableName)
          .select(
            '''
              *,
              profiles:parent_id ( * ),
              children:child_id ( * )
            ''',
          )
          .eq('parent_id', userId)
          .order(
            'date',
            ascending: true,
          )
          .withConverter(
            (json) =>
                json.map((e) => AppointmentModel.fromSeribase(e)).toList(),
          );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentModel> getAppointment({
    required String id,
  }) async {
    try {
      final data = await supabaseClient
          .from(
            AppointmentModel.tableName,
          )
          .select(
            '''
              *,
              profiles:parent_id ( * ),
              children:child_id ( * )
            ''',
          )
          .eq('id', id)
          .single();
      return AppointmentModel.fromSeribase(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentModel> setAppointment(AppointmentModel model) async {
    try {
      final result = await supabaseClient
          .from(AppointmentModel.tableName)
          .insert(
            model.toSeribase(),
          )
          .select(
            '''
            *,
            profiles:parent_id ( * ),
            children:child_id ( * )
          ''',
          )
          .limit(1)
          .single();
      return AppointmentModel.fromSeribase(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentModel> updateAppointment(AppointmentModel model) async {
    try {
      assert(model.id != null, 'ID appointment tidak ditemukan');
      await supabaseClient
          .from(AppointmentModel.tableName)
          .update(
            model.toSeribase(),
          )
          .eq('id', model.id!);

      return model;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAppointment(String id) async {
    return await supabaseClient
        .from(AppointmentModel.tableName)
        .delete()
        .eq('id', id);
  }
}
