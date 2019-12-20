import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  bool isFevorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageURL,
    this.isFevorite = false,
  });
  void _setFavValue(bool newValue){
    isFevorite = newValue;
    notifyListeners();
  }

  Future<void> tooglefavouriteStatus() async {
    final oldStatus = isFevorite;
    isFevorite = !isFevorite;
    notifyListeners();
    final url = 'https://flutter-update-1a6cb.firebaseio.com/products/$id.json';
    try {
     final response = await http.patch(
       url, 
       body: json.encode({
         'isFavourite': isFevorite,
     }),
     );
     if(response.statusCode >= 400){
       _setFavValue(oldStatus);
     }
    } 
    catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
