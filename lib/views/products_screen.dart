import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myshop_flutter/providers/products.dart';
import 'package:myshop_flutter/utils/app_routes.dart';
import 'package:myshop_flutter/widgets/app_drawer.dart';
import 'package:myshop_flutter/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.itemsCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              ProductItem(products[i]),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}