import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../screens/product_detail.dart';
import '../provider/products.dart';
class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageURL;

  // ProductItem(this.id, this.title, this.imageURL);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context,listen: false);

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),  
            child: GridTile(
            child:GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed(ProductDetail.routeName, arguments: product.id);
              },
              child: Image.network(
              product.imageURL,
              fit: BoxFit.cover,
            ),
            ),
            footer: Container(
              color: Colors.black.withOpacity(0.65),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                    Consumer<Product>(
                    builder: (ctx,product,child) =>
                       IconButton(
                      icon: Icon(
                        product.isFevorite ? 
                        Icons.favorite : Icons.favorite_border, 
                        color: Theme.of(context).accentColor,
                        ),
                      onPressed: () {
                        product.tooglefavouriteStatus();
                      },
                    ),
                  ),
                  Flexible(
                      child: Text(
                    product.title,
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  )),
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      cart.addItem(product.id, product.price, product.title);
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Added item to Cart!',),
                      duration:Duration(seconds: 2),
                      action: SnackBarAction(label: 'UNDO',onPressed: (){
                        cart.removeSingleItem(product.id);
                      },),
                      ));
                    },
                  )
                ],
              ),
            )),
    );
  }
}











// GridTileBar(
//         backgroundColor: Colors.black54,
//         leading: IconButton(icon: Icon(Icons.favorite),
//         onPressed:(){} ,),
//         title: Text(product.title,textAlign: TextAlign.center,),
//         trailing: IconButton(icon: Icon(Icons.shopping_cart),
//         onPressed: (){},),
//       ),
