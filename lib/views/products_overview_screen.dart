import 'package:flutter/material.dart';
import 'package:myshop_flutter/providers/products.dart';
import 'package:myshop_flutter/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products = productsProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (ctx, i) => ProductItem(products[i]),
      ),
    );
  }
}
