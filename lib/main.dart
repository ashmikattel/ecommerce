import 'package:flutter/material.dart';
import './provider/cart.dart';
import './provider/orders.dart';
import './screens/cart_screen.dart';
import './screens/edit_product.dart';
import './screens/product_detail.dart';
import './screens/product_overview_screen.dart';
import './provider/products_provider.dart';
import 'package:provider/provider.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        )
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        debugShowCheckedModeBanner: false,
        home: ProductOverviewScreen(),
        routes: {
          ProductDetail.routeName: (ctx) => ProductDetail(),
          CartScreen.routename:(ctx)=> CartScreen(),
          OrdersScreen.routename:(ctx)=> OrdersScreen(),
          UserProductScreen.routename:(ctx)=> UserProductScreen(),
          EDitProductScreen.routename:(ctx)=> EDitProductScreen(),
        },
      ),
    );
  }
}
