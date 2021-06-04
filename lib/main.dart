import 'package:DigitalShop/providers/cart.dart';
import 'package:DigitalShop/providers/orders.dart';
import 'package:DigitalShop/screens/cart_screen.dart';
import 'package:DigitalShop/screens/edit-product-screen.dart';
import 'package:DigitalShop/screens/orders_screen.dart';
import 'package:DigitalShop/screens/productDetails_Screen.dart';
import 'package:DigitalShop/screens/userProducts_screen.dart';

import './screens/products_overview_screen.dart';
import 'package:flutter/material.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Products(),
          ),
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProvider(create: (context) => Order())
        ],
        child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => ProductsInfoScreen(),
            '/productDetails': (ctx) => ProductDetails(),
            '/cartScreen': (ctx) => CartScreen(),
            'orders': (ctx) => OrdersScreen(),
            '/userProducts': (ctx) => UserProducts(),
            '/edit-Product': (ctx) => EditProductScreen()
          },
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
