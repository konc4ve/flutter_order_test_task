import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_order_test_task/core/api_exception.dart';
import 'package:flutter_order_test_task/order/data/model/order.dart';
import 'package:flutter_order_test_task/order/domain/order_repository.dart';
import 'package:http/http.dart' as http;

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({required http.Client client}) : _client = client;
  final http.Client _client;

  @override
  Future<Order> createOrder({
    required int userId,
    required int serviceId,
  }) async {
    final uri = Uri.parse('https://example.com/api/orders');

    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'userId': userId, 'serviceId': serviceId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data);
      } else {
        final data = jsonDecode(response.body);
        throw ApiException(data['message'] ?? 'Server error');
      }
    } on SocketException {
      throw ApiException('Нет подключения к интернету');
    } on TimeoutException {
      throw ApiException('Превышено время ожидания');
    } catch (e) {
      throw ApiException('Неизвестная ошибка');
    }
  }
}
