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
                      OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Colors.purple),
            ),
      onPressed: widget.cart.getTotal <= 0 || isLoading == true
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Order>(context).addOrder(
                  widget.cart.items.values.toList(), widget.cart.getTotal);

              setState(() {
                isLoading = false;
              });
              widget.cart.clearCart();
            },
    );
  }
}
