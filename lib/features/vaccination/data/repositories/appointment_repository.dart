import 'package:eimunisasi/features/health_worker/data/repositories/health_worker_repository.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class AppointmentRepository {
  final HealthWorkerRepository healthWorkerRepository;
  final SupabaseClient supabaseClient;

  AppointmentRepository(
    this.healthWorkerRepository,
    this.supabaseClient,
  );

  Future<List<AppointmentModel>> getAppointments({
    required String userId,
    String? sortCriteria,
  }) async {
    try {
      final orderBy = () {
        if (sortCriteria == 'date') {
          return 'date';
        } else if (sortCriteria == 'name') {
          return 'children ( name )';
        } else {
          return 'date';
        }
      }();
      final result = await supabaseClient
          .from(AppointmentModel.tableName)
          .select(
            '''
              *,
              profiles:parent_id ( * ),
              children ( * )
            ''',
          )
          .eq('parent_id', userId)
          .order(
            orderBy,
            ascending: true,
          )
          .withConverter(
            (json) => json
                .map(
                  (e) => AppointmentModel.fromSeribase(e),
                )
                .toList(),
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
      final result = AppointmentModel.fromSeribase(data);
      final healthWorkerById = await healthWorkerRepository.getHealthWorkerById(
        data['inspector_id'],
      );
      return result.copyWith(
        healthWorker: healthWorkerById,
      );
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
