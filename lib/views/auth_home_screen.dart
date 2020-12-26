import 'package:flutter/widgets.dart';
import 'package:myshop_flutter/providers/auth.dart';
import 'package:myshop_flutter/views/auth_screen.dart';
import 'package:myshop_flutter/views/products_overview_screen.dart';
import 'package:provider/provider.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? ProductsOverviewScreen() : AuthScreen();
  }
}
