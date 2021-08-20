import 'package:atc_kw/cart_bloc.dart';
import 'package:atc_kw/data.dart';
import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/screens/checkout.dart';
import 'package:atc_kw/utils/constants.dart';
import 'package:atc_kw/widgets/retail_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Your Cart",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            StreamBuilder<Object>(
                stream: CartBloc.instance.cartStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData &&
                      CartBloc.instance.cartItems.value.length != 0) {
                    // (productId -> qty)
                    Map productMap = snapshot.data;
                    List productIdList = productMap.keys.toList();

                    return _buildListView(productIdList);
                  }
                  return Expanded(
                      child: Center(child: Text("Your cart is empty...")));
                }),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: CartBloc.instance.cartStream,
                      builder: (context, AsyncSnapshot snapshot) {
                        double total = 0;
                        if (snapshot.hasData) {
                          // (productId -> qty)
                          Map productQtyMap = snapshot.data;
                          Map<int, Product>? productMap =
                              Data.instance.allProductMap;
                          productQtyMap.entries.forEach((element) {
                            int productId = element.key;
                            int qty = element.value;
                            double price = productMap![productId]!.price;
                            total += qty * price;
                          });
                        }
                        return Text('Rs $total',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold));
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (CartBloc.instance.cartItems.value.length == 0) {
                        Fluttertoast.showToast(
                          msg: "Please add some items to cart",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return;
                      }

                      CartBloc.instance.emptyCart();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Checkout(),
                          ));
                    },
                    child: Text('CHECKOUT'),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                  )
                ],
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: FloatingActionButton(
            // Your actual Fab
            onPressed: () {
              CartBloc.instance.emptyCart();
            },
            child: Icon(Icons.remove_shopping_cart),
            backgroundColor: Color(int.parse("0xff$colorFabIcon")),
          ),
        ));
  }

  Widget _buildListView(List productIdList) {
    // (productId -> Product)
    Map<int, Product>? allProductMap = Data.instance.allProductMap;

    return (productIdList == null)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: ListView.builder(
                itemCount: productIdList == null ? 0 : productIdList.length,
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  int id = productIdList[index];
                  return RetailItem(allProductMap![id]);
                }),
          );
  }
}
