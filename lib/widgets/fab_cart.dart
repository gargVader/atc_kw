import 'package:atc_kw/screens/cart.dart';
import 'package:atc_kw/utils/constants.dart';
import 'package:flutter/material.dart';

import '../cart_bloc.dart';

class FabCart extends StatefulWidget {
  const FabCart({Key? key}) : super(key: key);

  @override
  _FabCartState createState() => _FabCartState();
}

class _FabCartState extends State<FabCart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        child: Stack(
          alignment: Alignment(1.0, -0.9),
          children: [
            FloatingActionButton(
              // Your actual Fab
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cart(),
                    ));
              },
              child: Icon(Icons.shopping_cart),
              backgroundColor: Color(int.parse("0xff$colorFabIcon")),
            ),
            Container(
              // This is your Badge
              child: Center(
                  // Here you can put whatever content you want inside your Badge
                  child: StreamBuilder<Object>(
                stream: CartBloc.instance.cartStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    Map productMap = snapshot.data;
                    return Text('${productMap.length}',
                        style: TextStyle(color: Colors.white, fontSize: 10));
                  }
                  return Text('0',
                      style: TextStyle(color: Colors.white, fontSize: 10));
                },
              )),
              padding: EdgeInsets.all(0),

              constraints: BoxConstraints(minHeight: 20, minWidth: 20),
              decoration: BoxDecoration(
                // This controls the shadow
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 5,
                      color: Colors.black.withAlpha(50))
                ],
                borderRadius: BorderRadius.circular(16),
                color: Color(int.parse(
                    "0xff$colorAccent")), // This would be color of the Badge
              ),
            ),
          ],
        ),
      ),
    );
  }
}
