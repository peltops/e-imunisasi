import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eimunisasi/core/models/base_response_model.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:eimunisasi/features/payment/data/repositories/payment_repository.dart';

import '../../../data/models/order_model.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc(this.paymentRepository) : super(PaymentInitial()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<GetOrderDetailEvent>(_onGetOrderDetail);
  }

  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final response = await paymentRepository.initiate(event.request);
      emit(PaymentInitiateSuccess(response));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onGetOrderDetail(
    GetOrderDetailEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final response = await paymentRepository.getOrderDetail(event.orderId);
      if (response != null) {
        emit(OrderDetailSuccess(response));
      } else {
        emit(PaymentFailure('Order detail not found'));
      }
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }
}
