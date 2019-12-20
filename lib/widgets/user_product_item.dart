import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product.dart';
import '../provider/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scafold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EDitProductScreen.routename, arguments: id);
              },
              color: Colors.purple,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text(
                        'Do you really want to remove item from the list?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                      FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            try{
                               Provider.of<ProductsProvider>(context,
                                    listen: false)
                                .deleteProducts(id);
                                 Navigator.of(ctx).pop(true);
                            scafold.hideCurrentSnackBar();
                            scafold.showSnackBar(SnackBar(
                                content: Text(
                                  'Product Deleted.',
                                  style: TextStyle(fontSize: 15),
                                ),
                                duration: Duration(seconds: 2)));
                            }catch(error){
                              scafold.showSnackBar(SnackBar(
                                content: Text(
                                  'Deleting failed.',
                                  style: TextStyle(fontSize: 15),
                                ),
                                duration: Duration(seconds: 2)));
                            }
                          }),
                    ],
                  ),
                );
              },
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
