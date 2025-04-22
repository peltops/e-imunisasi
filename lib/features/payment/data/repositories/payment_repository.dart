import 'package:eimunisasi/core/models/base_response_model.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/order_model.dart';

@injectable
class PaymentRepository {
  final SupabaseClient supabaseClient;

  const PaymentRepository(this.supabaseClient);

  Future<BaseResponse<PaymentInitiateResponseModel>> initiate(
    PaymentInitiateRequestModel request,
  ) async {
    try {
      final fetch = await supabaseClient.functions.invoke(
        'payment/initiate',
        method: HttpMethod.post,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${supabaseClient.auth.currentSession?.accessToken}',
        },
      );

      if (fetch.status != 200 && fetch.status != 201) {
        throw Exception('Failed to initiate payment');
      }

      final data = fetch.data;
      final result = BaseResponse<PaymentInitiateResponseModel>.fromJson(
        data,
        (json) => PaymentInitiateResponseModel.fromSeribase(json),
      );

      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<BaseResponse<OrderModel>?> getOrderDetail(String orderId) async {
    try {
      final fetch = await supabaseClient.functions.invoke(
        'payment/order/$orderId',
        method: HttpMethod.get,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${supabaseClient.auth.currentSession?.accessToken}',
        },
      );

      if (fetch.status != 200 && fetch.status != 201) {
        throw Exception('Failed to get order detail');
      }

      final data = fetch.data;
      final result = BaseResponse<OrderModel>.fromJson(
        data,
        (json) => OrderModel.fromSeribase(json),
      );

      return result;
    } catch (e) {
      throw e;
    }
  }
}
