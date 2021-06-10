import 'package:DigitalShop/widgets/app_drawer.dart';
import 'package:DigitalShop/widgets/productsGrid.dart';
import 'package:flutter/material.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum FilterOptions {
  All,
  Favourits,
}

class ProductsInfoScreen extends StatefulWidget {
  @override
  _ProductsInfoScreenState createState() => _ProductsInfoScreenState();
}

class _ProductsInfoScreenState extends State<ProductsInfoScreen> {
  var _showonlyFav = false;
  var isInit = true;
  var isLoading = false;
  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .getandFetchProucts()
          .then((_) => setState(() {
                isLoading = false;
              }));
    }

    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dhanashee digital shop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedVal) {
                setState(() {
                  if (selectedVal == FilterOptions.Favourits) {
                    _showonlyFav = true;
                  } else {
                    _showonlyFav = false;
                  }
                });
              },
              child: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Show all'),
                      value: FilterOptions.All,
                    ),
                    PopupMenuItem(
                      child: Text('Show Favourites'),
                      value: FilterOptions.Favourits,
                    ),
                  ]),
          Consumer<Cart>(
              builder: (_, cart, ch) =>
                  Badge(child: ch, value: cart.itemCount.toString()),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed('/cartScreen');
                },
              )),
        ],
      ),
      body: (isLoading)
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showonlyFav),
      drawer: MainDrawer(),
    );
  }
}
