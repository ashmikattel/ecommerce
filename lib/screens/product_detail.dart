import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';


class ProductDetail extends StatelessWidget {
  // final String title;
  // final String imageURL;
  // final double price;

  //ProductDetail(this.title,this.imageURL,this.price);
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context,listen: false).findById(productId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),    
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Container(height: 250,
            width: MediaQuery.of(context).size.width,
            child: Image.network(loadedProduct.imageURL,fit: BoxFit.cover,),
            ),
            SizedBox(
              height: 10,
            ),
            Text('\$${loadedProduct.price}',
            style: TextStyle(color: Colors.grey,
            fontSize: 20,
            ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Text(loadedProduct.description,
              textAlign: TextAlign.center,softWrap: true,),
            )
          ],
        ),
      ),  
    );
  }
}