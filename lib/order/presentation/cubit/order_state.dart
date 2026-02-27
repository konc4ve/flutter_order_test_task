part of 'order_controller.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final Order order;

  OrderSuccess(this.order);
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}