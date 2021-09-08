import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/screens/searchDialog.dart';
import 'package:flutter/material.dart';

import '../data.dart';

// This SearchBar is present in the SearchDialog
class SearchBar extends StatelessWidget {
  Function? initiateSearch;
  Map<int, Pair<Product, double>>? allProductMap;
  TextEditingController controller = TextEditingController();

  SearchBar({
    required this.initiateSearch, required SearchDialog searchDialog,
  }) {
    allProductMap = Data.instance.allProductMap;
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(15),
        child: TextField(
          autofocus: true,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search items',
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (String text) {
            print('Submitted=' + text);
            initiateSearch!(query: text);
          },
        ));
  }
}