import 'package:flutter/material.dart';
import 'package:myshop_flutter/data/dummy_data.dart';
import 'package:myshop_flutter/models/product.dart';
import 'package:myshop_flutter/widgets/product_item.dart';

class ProductsOverviewScreen extends StatelessWidget {
  final List<Product> loadedProducts = DUMMY_PRODUCTS;

  @override
  Widget build(BuildContext context) {
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
        itemCount: loadedProducts.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (ctx, i) => ProductItem(loadedProducts[i]),
      ),
    );
  }
}
