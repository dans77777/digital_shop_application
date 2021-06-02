import 'package:DigitalShop/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItems extends StatelessWidget {
  final OrderItem orders;
  OrderItems(this.orders);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${orders.amount}'),
            subtitle: Text(DateFormat('dd mm yyyy').format(orders.dateTime)),
            trailing: Icon(Icons.more_horiz_sharp),
          )
        ],
      ),
    );
  }
}
