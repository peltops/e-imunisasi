import 'package:eimunisasi/core/models/base_response_model.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/order_model.dart';

@injectable
class PaymentRepository {
  final SupabaseClient supabaseClient;

  PaymentRepository({
    @factoryParam SupabaseClient? supabaseClient,
  }) : supabaseClient = supabaseClient ??
            SupabaseClient(
              dotenv.env['PAYMENT_URL'] ?? '',
              '',
            );

  Future<BaseResponse<PaymentInitiateResponseModel>> initiate(
    PaymentInitiateRequestModel request,
  ) async {
    try {
      final requestBody = request
          .copyWith(
            gateway: dotenv.env['PAYMENT_GATEWAY'] ?? 'midtrans',
            currency: dotenv.env['PAYMENT_CURRENCY'] ?? 'IDR',
          )
          .toSeribase();
      final fetch = await supabaseClient.functions.invoke(
        'payments/initiate',
        method: HttpMethod.post,
        body: requestBody,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
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
        'payments/order/$orderId',
        method: HttpMethod.get,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
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
