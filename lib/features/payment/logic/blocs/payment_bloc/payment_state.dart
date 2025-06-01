part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentInitiateSuccess extends PaymentState {
  final BaseResponse<PaymentInitiateResponseModel> response;

  const PaymentInitiateSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class OrderDetailSuccess extends PaymentState {
  final BaseResponse<OrderModel> response;

  const OrderDetailSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class PaymentFailure extends PaymentState {
  final String error;

  const PaymentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
