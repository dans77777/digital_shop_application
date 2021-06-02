import 'package:DigitalShop/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('cart items'),
      ),
      body: Column(
        children: <Widget>[
          Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Total'),
                      Chip(
                        label: Text('${cart.getTotal}'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      FlatButton(
                        onPressed: () {
                          Provider.of<Order>(context).addOrder(
                              cart.items.values.toList(), cart.getTotal);
                          cart.clearCart();
                        },
                        child: Text(
                          'ORDER NOW',
                          style: TextStyle(color: Colors.purple),
                        ),
                      )
                    ],
                  ))),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => ci.CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title),
            itemCount: cart.itemCount,
          ))
        ],
      ),
    );
  }
}
