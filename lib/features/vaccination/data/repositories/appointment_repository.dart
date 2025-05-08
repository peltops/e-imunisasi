import 'package:eimunisasi/features/health_worker/data/repositories/health_worker_repository.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:eimunisasi/features/payment/data/repositories/payment_repository.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_model.dart';
import 'package:eimunisasi/features/vaccination/data/models/appointment_payment_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class AppointmentRepository {
  final HealthWorkerRepository healthWorkerRepository;
  final PaymentRepository paymentRepository;
  final SupabaseClient supabaseClient;

  AppointmentRepository(
    this.healthWorkerRepository,
    this.paymentRepository,
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
      final orderById = await paymentRepository.getOrderDetail(
        result.orderId ?? '',
      );
      return AppointmentOrderEntity(
        appointment: result.copyWith(
          healthWorker: healthWorkerById,
        ),
        order: orderById?.data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentOrderEntity> setAppointment(AppointmentModel model) async {
    try {
      // initiate payment
      final payment = await paymentRepository.initiate(
        PaymentInitiateRequestModel(
          items: [
            ItemModel(
              /// This is booking fee ID
              id: '4cf70de1-35d6-4794-a249-9b79c328f086',
              quantity: 1,
            ),
          ],
        ),
      );
      final result = await supabaseClient
          .from(AppointmentModel.tableName)
          .insert(
            model.copyWith(orderId: payment.data?.orderId).toSeribase(),
          )
          .select(
            '''
            *,
            profiles:parent_id ( * ),
            children:child_id ( * )
          ''',
          )
          .limit(1)
          .withConverter(
            (json) => json
                .map(
                  (e) => AppointmentModel.fromSeribase(e),
                )
                .toList(),
          );
      final orderById = await paymentRepository.getOrderDetail(
        result.first.orderId ?? '',
      );
      return AppointmentOrderEntity(
        appointment: result.first,
        order: orderById?.data,
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
