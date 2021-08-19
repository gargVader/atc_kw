import 'package:atc_kw/screens/cart.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import '../cart_bloc.dart';

AppBar customAppbar(BuildContext context, String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    leading: IconButton(
      onPressed: () {},
      icon: Icon(Icons.menu),
    ),
    elevation: 0.0,
    centerTitle: true,
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Cart(),
              ));
        },
        icon: StreamBuilder<Object>(
            stream: CartBloc.instance.cartStream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Map productMap = snapshot.data;
                return Badge(
                  badgeContent: Text(
                    '${productMap.length}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                );
              }
              return Badge(
                badgeContent: Text(
                  '0',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Icon(
                  Icons.shopping_cart,
                ),
              );
            }),
      )
    ],
  );
}
