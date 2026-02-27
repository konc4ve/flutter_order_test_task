import 'package:bloc/bloc.dart';
import 'package:flutter_order_test_task/core/api_exception.dart';
import 'package:flutter_order_test_task/order/data/model/order.dart';
import 'package:flutter_order_test_task/order/domain/order_repository.dart';
import 'package:meta/meta.dart';

part 'order_state.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository repository;

  OrderController(this.repository) : super(OrderInitial());

  Future<void> submitOrder({
    required int userId,
    required int serviceId,
  }) async {
    emit(OrderLoading());
    try {
      final order = await repository.createOrder(
        userId: userId,
        serviceId: serviceId,
      );
      emit(OrderSuccess(order));
    } on ApiException catch (e) {
      emit(OrderError(e.message));
    } catch (_) {
      emit(OrderError('Unexpected error'));
    }
  }
}
