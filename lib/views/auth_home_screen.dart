import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myshop_flutter/providers/auth.dart';
import 'package:myshop_flutter/views/auth_screen.dart';
import 'package:myshop_flutter/views/products_overview_screen.dart';
import 'package:provider/provider.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return Consumer<Auth>(
            builder: (ctx, orders, child) {
              return auth.isAuth ? ProductsOverviewScreen() : AuthScreen();
            },
          );
        }
      },
    );
  }
}
