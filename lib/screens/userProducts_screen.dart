import 'package:DigitalShop/widgets/userProuct_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProducts extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .getandFetchProucts(true);
  }

  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _refreshProducts(context),
                        child: Consumer<Products>(
                          builder: (ctx, productsData, _) => Padding(
                            padding: EdgeInsets.all(10),
                            child: ListView.builder(
                              itemBuilder: (_, i) => Column(
                                children: <Widget>[
                                  UserProductItem(
                                      productsData.items[i].id,
                                      productsData.items[i].title,
                                      productsData.items[i].imageUrl),
                                  Divider()
                                ],
                              ),
                              itemCount: productsData.items.length,
                            ),
                          ),
                        ),
                      )));
  }
}
