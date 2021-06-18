import 'package:atc_kw/cart_bloc.dart';
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
      body: StreamBuilder<Object>(
          stream: cartbloc.cartItems,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && cartbloc.cartItems.value.length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        tileColor: Colors.grey[200],
                        contentPadding: EdgeInsets.all(10),
                        minVerticalPadding: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        key: Key(index.toString()),
                        leading: IconButton(
                          onPressed: () {
                            cartbloc.removeFromCart(snapshot.data[index]['id']);
                          },
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(snapshot.data[index]['name'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            "${snapshot.data[index]['quantity'].toString()}, ${snapshot.data[index]['price'].toString()}"),
                        trailing: IconButton(
                            onPressed: () {
                              cartbloc.addToCart(snapshot.data[index]);
                              print(cartbloc.cartItems.value);
                            },
                            icon: Icon(
                              Icons.shopping_basket,
                            )),
                      ),
                    );
                  });
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
