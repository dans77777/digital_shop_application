import 'package:DigitalShop/widgets/userProuct_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('user Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/edit-Product');
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (_, i) => Column(
            children: <Widget>[
              UserProductItem(productsData.items[i].id,
                  productsData.items[i].title, productsData.items[i].imageUrl),
              Divider()
            ],
          ),
          itemCount: productsData.items.length,
        ),
      ),
    );
  }
}
