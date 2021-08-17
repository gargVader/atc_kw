import 'package:atc_kw/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchBar extends StatelessWidget {
  Function? initiateSearch;
  List<Product>? allProductList;
  String? searchTerm;

  SearchBar(
      {required this.initiateSearch,
      required this.allProductList,
      required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = searchTerm!;
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(15),
      child: TypeAheadFormField<Product>(
        debounceDuration: Duration(milliseconds: 500),
        suggestionsCallback: (String query) {
          return allProductList!
              .where((product) =>
                  product.name.toLowerCase().contains(query.toString().trim()))
              .toList();
        },
        itemBuilder: (context, Product? product) {
          return ListTile(
            title: Text(product!.name),
          );
        },
        onSuggestionSelected: (Product? product) {
          print('Selected');
          textEditingController.text = product!.name;
          initiateSearch!(query: product.name);
        },
        textFieldConfiguration: TextFieldConfiguration(
            controller: textEditingController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search items',
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
            )),
      ),
    );
  }
}
