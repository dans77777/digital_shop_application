import 'package:DigitalShop/providers/orders.dart';
import 'package:DigitalShop/widgets/app_drawer.dart';
import 'package:DigitalShop/widgets/order_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/order_items.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
          future:
              Provider.of<Order>(context, listen: false).getAndFetchOrders(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (dataSnapshot.error != null) {
              return Center(child: Text('An error ocuured'));
            } else {
              return Consumer<Order>(
                builder: (context, orderData, child) => ListView.builder(
                    itemBuilder: (contex, i) => OrderItems(orderData.orders[i]),
                    itemCount: orderData.orders.length),
              );
            }
          }),
      drawer: MainDrawer(),
    );
  }
}
