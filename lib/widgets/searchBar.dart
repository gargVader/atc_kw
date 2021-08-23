import 'package:atc_kw/models/Product.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  Function? initiateSearch;
  Map<int, Product>? allProductMap;
  TextEditingController controller = TextEditingController();

  SearchBar({
    required this.initiateSearch,
    required this.allProductMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(15),
        child: TextField(
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
            // When the text is submitted, there might be two cases:
            // a. SearchBar is present in Home(): In this case, navigate to SearchPage()
            // b. SearchBar is present in SearchPage()
            initiateSearch!(query: text);
          },
        ));
  }
}
