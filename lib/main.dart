import 'package:flutter/material.dart';
import 'package:myshop/screens/product_overview_screen.dart';
import './provider/cart.dart';
import './provider/orders.dart';
import './screens/cart_screen.dart';
import './screens/edit_product.dart';
import './screens/product_detail.dart';
import './provider/products_provider.dart';
import 'package:provider/provider.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/auth-screen.dart';
import './provider/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            update: (ctx, auth, perviousProducts) => ProductsProvider(
                auth.token,
                auth.userId,
                perviousProducts == null ? [] : perviousProducts.items),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, perviousOrders) => Orders(auth.token,
                perviousOrders == null ? [] : perviousOrders.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            debugShowCheckedModeBanner: false,
            home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetail.routeName: (ctx) => ProductDetail(),
              CartScreen.routename: (ctx) => CartScreen(),
              OrdersScreen.routename: (ctx) => OrdersScreen(),
              UserProductScreen.routename: (ctx) => UserProductScreen(),
              EDitProductScreen.routename: (ctx) => EDitProductScreen(),
            },
          ),
        ));
  }
}
