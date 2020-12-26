import 'package:flutter/material.dart';
import 'package:myshop_flutter/providers/cart.dart';
import 'package:myshop_flutter/providers/orders.dart';
import 'package:myshop_flutter/providers/products.dart';
import 'package:myshop_flutter/utils/app_routes.dart';
import 'package:myshop_flutter/views/auth_screen.dart';
import 'package:myshop_flutter/views/cart_screen.dart';
import 'package:myshop_flutter/views/orders_screen.dart';
import 'package:myshop_flutter/views/product_detail_screen.dart';
import 'package:myshop_flutter/views/product_form_screen.dart';
import 'package:myshop_flutter/views/products_overview_screen.dart';
import 'package:myshop_flutter/views/products_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await DotEnv().load('.env_dev');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.AUTH: (ctx) => AuthScreen(),
          AppRoutes.HOME: (ctx) => ProductsOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
