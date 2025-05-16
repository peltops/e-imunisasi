import 'package:eimunisasi/features/payment/data/models/order_model.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_payment_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  Future<AppointmentOrderEntity> getAppointment({
    required String id,
  }) async {
    try {
      final fetch = await supabaseClient.functions.invoke(
        'api/appointments/$id',
        method: HttpMethod.get,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${supabaseClient.auth.currentSession?.accessToken}',
        },
      );
      if (fetch.status != 200 && fetch.status != 201) {
        throw Exception('Failed to initiate payment');
      }

      final data = fetch.data['data'];
      if (data == null) {
        throw Exception('Data not found');
      }
      final result = AppointmentModel.fromSeribase(data);
      final order =
          data['order'] != null ? OrderModel.fromSeribase(data['order']) : null;
      return AppointmentOrderEntity(
        appointment: result,
        order: order,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentOrderEntity> setAppointment(AppointmentModel model) async {
    try {
      final result = await supabaseClient.functions.invoke(
        'api/appointments',
        method: HttpMethod.post,
        body: model.toSeribase()
          ..addAll({
            'gateway': dotenv.env['PAYMENT_GATEWAY'] ?? 'midtrans',
            'currency': dotenv.env['PAYMENT_CURRENCY'] ?? 'IDR',
          }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${supabaseClient.auth.currentSession?.accessToken}',
        },
      );
      if (result.status != 200 && result.status != 201) {
        throw Exception('Failed to set appointment');
      }
      final data = result.data['data'];
      if (data == null) {
        throw Exception('Data not found');
      }
      final appointment = AppointmentModel.fromSeribase(data);
      final orderById =
          data['order'] != null ? OrderModel.fromSeribase(data['order']) : null;
      return AppointmentOrderEntity(
        appointment: appointment,
        order: orderById,
      );
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
