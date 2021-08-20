import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/utils/constants.dart';
import 'package:flutter/material.dart';

import '../cart_bloc.dart';

class ProductDetail extends StatefulWidget {
  Product product;

  ProductDetail(this.product);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(widget.product.imageUrl),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.visible,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      widget.product.size,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '₹ ' + widget.product.price.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                          maxRadius: 20,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            onPressed: () {
                              CartBloc.instance.addToCart(widget.product);
                              // print(CartBloc.instance.cartItems.value);
                            },
                            icon: Icon(Icons.add),
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            constraints: BoxConstraints(),
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: FittedBox(
                              child: StreamBuilder(
                            stream: CartBloc.instance.cartStream,
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                Map productMap = snapshot.data;
                                var qty = (!productMap.containsKey(widget.product.id) || productMap[widget.product.id] == null)
                                    ? 0
                                    : productMap[widget.product.id];
                                return Text('$qty');
                              }
                              return Text('0');
                            },
                          ))),
                      CircleAvatar(
                          maxRadius: 20,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            onPressed: () {
                              CartBloc.instance
                                  .removeFromCart(widget.product.id);
                            },
                            icon: Icon(Icons.remove),
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            constraints: BoxConstraints(),
                          )),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Description",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Text(DUMMY_TEXT),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
