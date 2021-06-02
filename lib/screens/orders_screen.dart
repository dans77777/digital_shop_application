import 'package:DigitalShop/providers/orders.dart';
import 'package:DigitalShop/widgets/app_drawer.dart';
import 'package:DigitalShop/widgets/order_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_items.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (contex, i) => OrderItems(ordersData.orders[i]),
          itemCount: ordersData.orders.length,
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}
