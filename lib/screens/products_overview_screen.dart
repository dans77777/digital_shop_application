import 'package:DigitalShop/widgets/productsGrid.dart';
import 'package:flutter/material.dart';

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
                    )
                  ])
        ],
      ),
      body: ProductsGrid(_showonlyFav),
    );
  }
}
