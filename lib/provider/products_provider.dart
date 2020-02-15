import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/http_exception.dart';
import './products.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageURL:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageURL:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageURL:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageURL:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
    //   Product(
    //     id: 'p5',
    //     title: 'Coffee beans',
    //     description: 'Prepare your coffee whenever you want.',
    //     price: 50.00,
    //     imageURL:
    //         'https://cdn.pixabay.com/photo/2019/12/02/18/44/coffee-beans-4668463__340.jpg',
    //   ),
    //   Product(
    //     id: 'p6',
    //     title: 'Christmas Gift',
    //     description: 'Gift your loved ones.',
    //     price: 60.00,
    //     imageURL:
    //         'https://cdn.pixabay.com/photo/2019/11/22/18/41/christmas-4645449_960_720.jpg',
    //   ),
    //   Product(
    //     id: 'p7',
    //     title: 'Weeding Dress',
    //     description: 'Look elligent in your special day.',
    //     price: 120.00,
    //     imageURL:
    //         'https://cdn.pixabay.com/photo/2016/06/29/04/39/wedding-dresses-1486004_960_720.jpg',
    //   ),
    //   Product(
    //     id: 'p8',
    //     title: 'Oil',
    //     description: 'Its the best quality olive oil you can get in the city.',
    //     price: 10.00,
    //     imageURL:
    //         'https://cdn.pixabay.com/photo/2015/10/02/15/59/olive-oil-968657_960_720.jpg',
    //   ),
    //   Product(
    //     id: 'p9',
    //     title: 'Watch',
    //     description: 'Get the best wrist watch in the town.',
    //     price: 40.00,
    //     imageURL:
    //         'https://cdn.pixabay.com/photo/2018/01/18/19/06/time-3091031_960_720.jpg',
    //   ),
    //   Product(
    //     id: 'p10',
    //     title: 'Office Items',
    //     description: 'Office acessories you need every day.',
    //     price: 300.00,
    //     imageURL:
    //         'https://cdn.pixabay.com/photo/2017/04/06/11/24/fashion-2208045__340.jpg',
    //   ),
  ];

  final String authToken;
  final String userId;
  ProductsProvider( this.authToken, this.userId, this._items );

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFevorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId' : '';
    var url = 'https://flutter-update-1a6cb.firebaseio.com/products.json?auth=$authToken&$filterString"';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if(extractedData ==null){
      return;
    }
    url = 'https://flutter-update-1a6cb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
    final fevoriteResponse = await http.get(url);
    final fevoriteData = json.decode(fevoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFevorite: fevoriteData == null  ? false: fevoriteData[prodId] ?? false,
            imageURL: prodData['imageURL'],
            ),
          );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://flutter-update-1a6cb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageURL': product.imageURL,
          'price': product.price,
          'creatorId': userId
        }),
      );
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageURL: product.imageURL,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      //items.insert(0, newProduct); //at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodINdex = _items.indexWhere((prod) => prod.id == id);
    if (prodINdex >= 0) {
      final url =
          'https://flutter-update-1a6cb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageURL': newProduct.imageURL,
          }));
      _items[prodINdex] = newProduct;
      notifyListeners();
    } else {
    }
  }

  Future<void> deleteProducts(String id) async {
    final url = 'https://flutter-update-1a6cb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    existingProduct = null;
    
  }
}
