import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myshop_flutter/providers/orders.dart';
import 'package:myshop_flutter/widgets/app_drawer.dart';
import 'package:myshop_flutter/widgets/order_widget.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
      ),
    );
  }
}
