import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/core/models/base_response_model.dart';
import 'package:eimunisasi/features/payment/data/models/order_model.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:eimunisasi/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:eimunisasi/features/payment/data/repositories/payment_repository.dart';
import 'package:eimunisasi/features/payment/logic/blocs/payment_bloc/payment_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentRepository extends Mock implements PaymentRepository {}

void main() {
  late MockPaymentRepository mockPaymentRepository;
  late PaymentBloc paymentBloc;

  setUp(() {
    mockPaymentRepository = MockPaymentRepository();
    paymentBloc = PaymentBloc(mockPaymentRepository);
  });

  tearDown(() {
    paymentBloc.close();
  });

  test('initial state should be PaymentInitial', () {
    expect(paymentBloc.state, equals(PaymentInitial()));
  });

  group('InitiatePaymentEvent', () {
    final request = PaymentInitiateRequestModel();
    final response = BaseResponse<PaymentInitiateResponseModel>();

    blocTest<PaymentBloc, PaymentState>(
      'emits [PaymentLoading, PaymentInitiateSuccess] when successful',
      build: () {
        when(() => mockPaymentRepository.initiate(request))
            .thenAnswer((_) async => response);
        return paymentBloc;
      },
      act: (bloc) => bloc.add(InitiatePaymentEvent(request)),
      expect: () => [
        PaymentLoading(),
        PaymentInitiateSuccess(response),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits [PaymentLoading, PaymentFailure] when error occurs',
      build: () {
        when(() => mockPaymentRepository.initiate(request))
            .thenThrow(Exception('Error'));
        return paymentBloc;
      },
      act: (bloc) => bloc.add(InitiatePaymentEvent(request)),
      expect: () => [
        PaymentLoading(),
        PaymentFailure('Exception: Error'),
      ],
    );
  });

  group('GetOrderDetailEvent', () {
    const orderId = '123';
    final orderDetail = BaseResponse<OrderModel>();

    blocTest<PaymentBloc, PaymentState>(
      'emits [PaymentLoading, OrderDetailSuccess] when successful',
      build: () {
        when(() => mockPaymentRepository.getOrderDetail(orderId))
            .thenAnswer((_) async => orderDetail);
        return paymentBloc;
      },
      act: (bloc) => bloc.add(GetOrderDetailEvent(orderId)),
      expect: () => [
        PaymentLoading(),
        OrderDetailSuccess(orderDetail),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits [PaymentLoading, PaymentFailure] when order not found',
      build: () {
        when(() => mockPaymentRepository.getOrderDetail(orderId))
            .thenAnswer((_) async => null);
        return paymentBloc;
      },
      act: (bloc) => bloc.add(GetOrderDetailEvent(orderId)),
      expect: () => [
        PaymentLoading(),
        PaymentFailure('Order detail not found'),
      ],
    );

    blocTest<PaymentBloc, PaymentState>(
      'emits [PaymentLoading, PaymentFailure] when error occurs',
      build: () {
        when(() => mockPaymentRepository.getOrderDetail(orderId))
            .thenThrow(Exception('Error'));
        return paymentBloc;
      },
      act: (bloc) => bloc.add(GetOrderDetailEvent(orderId)),
      expect: () => [
        PaymentLoading(),
        PaymentFailure('Exception: Error'),
      ],
    );
  });
}
