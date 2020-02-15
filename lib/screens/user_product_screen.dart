import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../provider/products_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routename = '/user-Products';
  Future<void>_refreshProducts(BuildContext context)async{
    Provider.of<ProductsProvider>(context).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
            Navigator.of(context).pushNamed(EDitProductScreen.routename,);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh:()=> _refreshProducts(context),
              child: Padding(
          padding: EdgeInsets.all(8), 
          child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (context, i) => Column(
              children: <Widget>[
                UserProductItem(title: productData.items[i].title, 
                    imageUrl:productData.items[i].imageURL,
                    id:productData.items[i].id
                    ),
                    Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
