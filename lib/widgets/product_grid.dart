import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../provider/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;

  ProductGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productData =  Provider.of<ProductsProvider>(context);
    final products = showFavs ? productData.favoriteItems : productData.items;
    return Center(
      child: products.length >0? GridView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: products.length,
        itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
          // builder: (c)=> products[i],
          value: products[i],
          child: ProductItem(
          // products[i].id,
          // products[i].title,
          // products[i].imageURL
          ), 
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
          ),
      ): Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Text('Sorry''\n''No Data Found!!',style: TextStyle(fontSize: 30,color: Colors.black,fontStyle: FontStyle.italic),)
      ]),
    );
  }
}