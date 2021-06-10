import 'package:DigitalShop/providers/auth.dart';
import 'package:DigitalShop/providers/cart.dart';
import 'package:DigitalShop/providers/orders.dart';
import 'package:DigitalShop/screens/auth_screen.dart';
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
          ChangeNotifierProvider(create: (context) => Cart()),

          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (context, auth, previousProduct) => Products(
                auth.token,
                auth.userId,
                previousProduct == null ? [] : previousProduct.items),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Order>(
            update: (context, auth, previousProduct) => Order(
                auth.token,
                auth.userId,
                previousProduct == null ? [] : previousProduct.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
            ),
            home: auth.isAuth ? ProductsInfoScreen() : AuthScreen(),
            routes: {
              '/productsInfo': (ctx) => ProductsInfoScreen(),
              '/productDetails': (ctx) => ProductDetails(),
              '/cartScreen': (ctx) => CartScreen(),
              'orders': (ctx) => OrdersScreen(),
              '/userProducts': (ctx) => UserProducts(),
              '/edit-Product': (ctx) => EditProductScreen()
            },
          ),
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
