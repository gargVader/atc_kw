import 'package:atc_kw/screens/items.dart';
import 'package:flutter/material.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';

import '../cart_bloc.dart';

class SearchPage extends StatefulWidget {
  final String? searchItem;
  SearchPage({
    Key? key,
    this.searchItem,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> searchItems = [];

  void searchforItem() {
    for (int i = 0; i < items.length; i++) {
      items[i]['name'].toString().toLowerCase() == widget.searchItem
          ? searchItems.add(items[i])
          : "Not Found";
    }
  }

  @override
  void initState() {
    searchforItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Page"),
      ),
      body: ListView.builder(
          itemCount: searchItems.length,
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
                leading: Icon(
                  Icons.store,
                  color: Colors.black,
                ),
                title: Text(
                  searchItems[index]['name'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${searchItems[index]['quantity'].toString()}, ${searchItems[index]['price'].toString()}",
                ),
                trailing: IconButton(
                    onPressed: () {
                      cartbloc.addToCart(searchItems[index]);
                      print(cartbloc.cartItems.value);
                    },
                    icon: Icon(Icons.shopping_cart)),
              ),
            );
          }),
    );
  }
}
