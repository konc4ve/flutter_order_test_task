import 'package:flutter_order_test_task/order/data/model/order.dart';


abstract interface class OrderRepository {
  
  

  Future<Order> createOrder({
    required int userId,
    required int serviceId,
  });
}