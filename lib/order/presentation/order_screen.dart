import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_order_test_task/order/data/repository/order_repository_impl.dart';
import 'package:flutter_order_test_task/order/presentation/cubit/order_controller.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderController>(
      create: (_) =>
          OrderController(OrderRepositoryImpl(client: http.Client())),
      child: Scaffold(
        appBar: AppBar(title: const Text('Создание заказа')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<OrderController, OrderState>(
              builder: (context, state) {
                final controller = context.read<OrderController>();
                final isLoading = state is OrderLoading;
                final errorMessage = state is OrderError ? state.message : null;
                final order = state is OrderSuccess ? state.order : null;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const CircularProgressIndicator()
                    else if (order != null)
                      Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 64,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Заказ #${order.orderId} создан!',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      )
                    else if (errorMessage != null)
                      Column(
                        children: [
                          Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                controller.submitOrder(userId: 1, serviceId: 2);
                              },
                        child: Text(
                          isLoading
                              ? 'Создание...'
                              : (errorMessage != null
                                    ? 'Повторить'
                                    : 'Создать заказ'),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
