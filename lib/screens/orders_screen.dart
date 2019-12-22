import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../provider/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routename = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;

  // @override
  // void initState() {
  //   // Future.delayed(Duration.zero).then((_) {

  //   //   _isLoading = true;
  //   // .then((_){
  //   //   setState(() {
  //   //   _isLoading = false;
  //   // });
  //   // });

  //   //});
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                //we can do error handeling here
                return Center(
                  child: Text(
                    "An error occured!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderData, child) =>
                        orderData.orders.length < 0
                            ? Center(
                                child: Text(
                                  "No order yet!!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: orderData.orders.length,
                                itemBuilder: (ctx, i) =>
                                    OrderItem(orderData.orders[i])));
              }
            }
          },
        ));
  }
}

// _isLoading
//     ?
//     : orderData.orders.length > 0
//         ?
//         :
