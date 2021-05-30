import 'package:DigitalShop/providers/product.dart';
import 'package:DigitalShop/providers/products.dart';
import 'package:DigitalShop/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20),
      itemBuilder: (context, i) =>
          ProductItem(products[i].id, products[i].title, products[i].imageUrl),
      itemCount: products.length,
    );
  }
}
