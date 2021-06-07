import 'dart:convert';

import 'package:DigitalShop/providers/product.dart';
import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFavs {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> getandFetchProucts() async {
    const url =
        'https://flutter-shop-app-38c70-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loading = [];
      extractedData.forEach((prodid, prodData) {
        loading.add(Product(
            id: prodid,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavourite: prodData['isFavourite'],
            imageUrl: prodData['imageUrl']));
      });
      _items = loading;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    const url =
        'https://flutter-shop-app-38c70-default-rtdb.firebaseio.com/products.json';
    try {
      await http
          .post(url,
              body: json.encode({
                'title': product.title,
                'description': product.description,
                'imageUrl': product.imageUrl,
                'price': product.price,
                'isFavourite': product.isFavourite,
              }))
          .then((response) {
        final newProduct = new Product(
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl,
            id: json.decode(response.body)['name']);

        _items.add(newProduct);
        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://flutter-shop-app-38c70-default-rtdb.firebaseio.com/products/$id.json';
    final prodIndex = _items.indexWhere((element) => element.id == id);
    await http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }));

    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
