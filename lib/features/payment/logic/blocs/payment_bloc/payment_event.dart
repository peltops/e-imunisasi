part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiatePaymentEvent extends PaymentEvent {
  final PaymentInitiateRequestModel request;

  const InitiatePaymentEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class GetOrderDetailEvent extends PaymentEvent {
  final String orderId;

  const GetOrderDetailEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
