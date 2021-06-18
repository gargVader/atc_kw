import 'package:rxdart/rxdart.dart';

class CartBloc {
  BehaviorSubject<List<Map<String, dynamic>>> get cartItems => _cartItems;
  final BehaviorSubject<List<Map<String, dynamic>>> _cartItems =
      BehaviorSubject<List<Map<String, dynamic>>>.seeded([]);

  void addToCart(Map<String, dynamic> item) {
    var items = _cartItems.value;
    items.add(item);
    _cartItems.sink.add(items);
  }

  void removeFromCart(int id) {
    print(id);
    var items = _cartItems.value;
    for (int i = 0; i < items.length; i++) {
      if (id == items[i]['id']) {
        items.remove(items[i]);
      }
    }
    _cartItems.sink.add(items);
  }

  void dispose() {
    _cartItems.close();
  }
}

final cartbloc = CartBloc();
