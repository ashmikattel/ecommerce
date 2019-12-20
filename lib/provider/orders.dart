import 'package:myshop/provider/products.dart';

import '../model/http_exception.dart';
import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://flutter-update-1a6cb.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if(extractedData ==null){
      return;
    }
    
    extractedData.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderItem(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ),
                  )
             .toList(
            ) 
          ),
        );
      },
    );
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartproducts, double total) async {
    const url = 'https://flutter-update-1a6cb.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartproducts
          .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList(),
        }));

        // _orders.insert(0, 
        //  OrderItem(
        //   id: json.decode(response.body)['name'],
        //   amount: total,
        //   dateTime: timeStamp,
        //   products: cartproducts,
        // ),);
    notifyListeners();
  }
  
  // Future<void> deleteOrders(String id)async{
  //   const url = 'https://flutter-update-1a6cb.firebaseio.com/orders/$id.json';
  //   final response = await http.delete(url);
  //   final existingOrderIndex = orders.indexWhere((ord)=>ord.id ==id); 
  //   notifyListeners();
  //   orders.removeAt(existingOrderIndex);
  // }
  Future<void> deleteOrders({String id}) async {
    final url = 'https://flutter-update-1a6cb.firebaseio.com/orders/$id.json';
    final existingOrderIndex = orders.indexWhere((ord) => ord.id == id);
    var existingOrders = orders[existingOrderIndex];
    orders.removeAt(existingOrderIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      orders.insert(existingOrderIndex, existingOrders);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    existingOrders = null;
    
  }
}
