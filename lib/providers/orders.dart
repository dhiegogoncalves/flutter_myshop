import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myshop_flutter/providers/cart.dart';
import 'package:myshop_flutter/utils/constants.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  final _baseUrl = '${Constants.baseApiUrl}/orders';
  String _token;
  List<Order> _items = [];

  Orders(this._token, this._items);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    final response = await http.get('$_baseUrl.json?auth=$_token');
    Map<String, dynamic> data = json.decode(response.body);
    List<Order> loadedItems = [];

    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedItems.add(Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  productId: item['productId'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
        ));
      });
    }

    _items = loadedItems.reversed.toList();
    notifyListeners();
    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      '$_baseUrl.json?auth=$_token',
      body: json.encode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map(
              (cartItem) => {
                'id': cartItem.id,
                'productId': cartItem.productId,
                'title': cartItem.title,
                'quantity': cartItem.quantity,
                'price': cartItem.price,
              },
            )
            .toList(),
      }),
    );

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}
