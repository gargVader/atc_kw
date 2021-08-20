import 'package:atc_kw/data.dart';
import 'package:rxdart/rxdart.dart';

import 'models/Product.dart';

class CartBloc {
  late final BehaviorSubject<Map> _cartItems;
  static CartBloc instance = new CartBloc._();

  CartBloc._() {
    // (productId -> quantity)
    _cartItems = BehaviorSubject<Map<int, int>>.seeded(new Map());
  }

  BehaviorSubject<Map> get cartItems => _cartItems;

  Stream<Map> get cartStream => _cartItems.stream;

  void addToCart(Product product) {
    print('Adding to cart');
    int id = product.id;
    // (productId -> qty )
    Map productMap = _cartItems.value;
    if (productMap[id] == null) {
      productMap[id] = 1;
    } else {
      productMap[id]++;
    }
    _cartItems.sink.add(productMap);
  }

  void removeFromCart(int id) {
    print(id);
    Map productMap = _cartItems.value;

    if (productMap.containsKey(id)) {
      if (productMap[id] == 1) {
        productMap.remove(id);
      } else {
        productMap[id]--;
      }
      _cartItems.sink.add(productMap);
    }
    // var items = _cartItems.value;
    // for (int i = 0; i < items.length; i++) {
    //   if (id == items[i]['id']) {
    //     items.remove(items[i]);
    //   }
    // }
    // _cartItems.sink.add(items);
  }

  void emptyCart() {
    _cartItems.sink.add(new Map<int, int>());
  }

  double get totalPrice{
    double total = 0;
    Map productQtyMap = _cartItems.value;
    Map<int, Product>? productMap = Data.instance.allProductMap;

    productQtyMap.entries.forEach((element) {
      int productId = element.key;
      int qty = element.value;
      double price = productMap![productId]!.price;

      total+= qty*price;
    });

    return total;
  }

  void dispose() {
    _cartItems.close();
  }
}
