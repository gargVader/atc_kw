import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/screens/cart.dart';
import 'package:atc_kw/screens/productDetail.dart';
import 'package:flutter/material.dart';

import '../cart_bloc.dart';

/// Widget for RetailItem. Just needs the product onject that needs to displayed.
/// The qty will be fetched from cartStream
class RetailItem extends StatefulWidget {
  Product? product;
  bool _visible = true;

  RetailItem(this.product);

  @override
  _RetailItemState createState() => _RetailItemState();
}

class _RetailItemState extends State<RetailItem> {
  @override
  Widget build(BuildContext context) {
    Product? product = widget.product;
    product!.imageUrl = getImageUrl(product.name);

    Map productMap = CartBloc.instance.cartItems.value;
    if (productMap[product] != null) {
      setState(() {
        widget._visible = false;
      });
    }

    return Card(
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetail(product),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: constraints.maxWidth * 0.15,
                    child: Image(
                      image: NetworkImage(product.imageUrl),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(
                              product.brand.toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              product.name.toUpperCase(),
                              style: Theme.of(context).textTheme.title,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                                '${product.sizeInt} ${product.unit.toUpperCase()}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('\₹ ${product.price}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: (widget._visible)
                        ? TextButton(
                            style: TextButton.styleFrom(
                                minimumSize: Size.zero, // <-- Add this
                                padding: EdgeInsets.all(5),
                                backgroundColor: Theme.of(context)
                                    .primaryColor // <-- and this
                                ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                Text(
                                  'Add',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            onPressed: () {
                              setState(() {
                                widget._visible = false;
                              });
                            },
                          )
                        : Container(
                            child: Row(
                              children: [
                                CircleAvatar(
                                    maxRadius: 15,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: IconButton(
                                      onPressed: () {
                                        CartBloc.instance.addToCart(product);
                                        // print(CartBloc.instance.cartItems.value);
                                      },
                                      icon: Icon(Icons.add),
                                      padding: EdgeInsets.zero,
                                      color: Colors.white,
                                      constraints: BoxConstraints(),
                                    )),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2),
                                    child: FittedBox(
                                        child: StreamBuilder(
                                      stream: CartBloc.instance.cartStream,
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          // (productId -> qty)
                                          Map productMap = snapshot.data;
                                          var qty = (!productMap.containsKey(product.id) || productMap[product.id] == null)
                                              ? 0
                                              : productMap[product.id];
                                          print('qty = $qty');
                                          return Text('$qty');
                                        }
                                        return Text('0');
                                      },
                                    ))),
                                CircleAvatar(
                                    maxRadius: 15,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: IconButton(
                                      onPressed: () {
                                        CartBloc.instance
                                            .removeFromCart(product.id);
                                      },
                                      icon: Icon(Icons.remove),
                                      padding: EdgeInsets.zero,
                                      color: Colors.white,
                                      constraints: BoxConstraints(),
                                    )),
                              ],
                            ),
                          ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );

    return Card(
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        minVerticalPadding: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        key: Key("0"),
        leading: Image(
          image: NetworkImage(product.imageUrl),
        ),
        title: Text(
          product.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${product.size}, ${product.price}",
        ),
        trailing: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cart(),
                  ));
              // cartbloc.addToCart(items[index]);
              // print(cartbloc.cartItems.value);
            },
            icon: Icon(Icons.shopping_cart)),
      ),
    );
  }

  String getImageUrl(String name) {
    final String imageUrl;
    if (name.toLowerCase().contains("tomato")) {
      imageUrl =
          "https://www.bigbasket.com/media/uploads/p/s/40022638_3-fresho-tomato-local-organically-grown.jpg";
    } else if (name.toLowerCase().contains("onion")) {
      imageUrl =
          "https://www.bigbasket.com/media/uploads/p/s/40023472_3-fresho-onion-organically-grown.jpg";
    } else if (name.toLowerCase().contains("potato")) {
      imageUrl =
          "https://www.bigbasket.com/media/uploads/p/s/40023476_4-fresho-potato-organically-grown.jpg";
    } else if (name.toLowerCase().contains("maggi")) {
      imageUrl =
          "https://www.bigbasket.com/media/uploads/p/s/266109_15-maggi-2-minute-instant-noodles-masala.jpg";
    } else if (name.toLowerCase().contains("aashirvaad atta")) {
      imageUrl =
          "https://www.bigbasket.com/media/uploads/p/s/126906_7-aashirvaad-atta-whole-wheat.jpg";
    } else if (name.toLowerCase().contains("mango")) {
      imageUrl =
          "https://www.bigbasket.com/media/uploads/p/l/10000304_4-fresho-mallika-mango.jpg";
    } else if (name.toLowerCase().contains("banana")) {
      imageUrl =
          "https://www.bigbasket.com/media/uploads/p/l/40179390_6-fresho-baby-banana-robusta.jpg";
    } else {
      imageUrl = "https://www.honestbee.tw/images/placeholder.jpg";
    }
    return imageUrl;
  }
}
