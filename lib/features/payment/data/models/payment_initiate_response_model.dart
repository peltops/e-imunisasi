import 'package:equatable/equatable.dart';

class PaymentInitiateResponseModel extends Equatable {
  final String? orderId, gateway, redirectUrl, token;

  const PaymentInitiateResponseModel({
    this.gateway,
    this.orderId,
    this.redirectUrl,
    this.token,
  });

  @override
  List<Object?> get props => [
        orderId,
        gateway,
        redirectUrl,
        token,
      ];

  factory PaymentInitiateResponseModel.fromSeribase(Map<String, dynamic> data) {
    return PaymentInitiateResponseModel(
      orderId: data["order_id"] as String?,
      gateway: data["gateway"] as String?,
      redirectUrl: data["redirect_url"] as String?,
      token: data["token"] as String?,
    );
  }

  Map<String, dynamic> toSeribase() {
    return {
      if (orderId != null) "order_id": orderId,
      if (gateway != null) "gateway": gateway,
      if (redirectUrl != null) "redirect_url": redirectUrl,
      if (token != null) "token": token,
    };
  }
}
