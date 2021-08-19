import 'package:atc_kw/cart_bloc.dart';
import 'package:atc_kw/data.dart';
import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/widgets/retail_item.dart';
import 'package:flutter/material.dart';

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
                return Center(child: Text("Your cart is empty..."));
              }),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total : Rs 450',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('CHECKOUT'),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                )
              ],
            ),
          )
        ],
      ),
    );
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
                itemCount: productIdList == null
                    ? 0
                    : productIdList.length,
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  int id = productIdList[index];
                  return RetailItem(allProductMap![id]);
                }),
          );
  }
}
