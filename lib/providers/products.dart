import 'dart:convert';
import '../models/http_exception.dart';
import 'package:DigitalShop/providers/product.dart';
import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFavs {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  final String token;
  final String userId;
  Products(this.token, this.userId, param1);
  Future<void> getandFetchProucts() async {
    var url =
        'https://flutter-shop-app-38c70-default-rtdb.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      url =
          'https://flutter-shop-app-38c70-default-rtdb.firebaseio.com/Favouriteproducts/$userId.json?auth=$token';
      final favResponse = await http.get(url);
      final extractfav = json.decode(favResponse.body);
      final List<Product> loading = [];
      extractedData.forEach((prodid, prodData) {
        loading.add(Product(
          id: prodid,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavourite: extractfav == null ? false : extractfav[prodid] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loading;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-shop-app-38c70-default-rtdb.firebaseio.com/products.json?auth=$token';
    try {
      await http
          .post(url,
              body: json.encode({
                'title': product.title,
                'description': product.description,
                'imageUrl': product.imageUrl,
                'price': product.price,
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
        'https://flutter-shop-app-38c70-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
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

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shop-app-38c70-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    notifyListeners();
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    {
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete product');
      }
      existingProduct = null;
    }
  }
}
