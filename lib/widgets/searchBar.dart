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
            initiateSearch!(query: text);
          },
        )

        // TypeAheadFormField<Product>(
        //   debounceDuration: Duration(milliseconds: 500),
        //   suggestionsCallback: (String query) {
        //
        //     List<Product> productList = [];
        //     allProductMap!.entries.forEach((element) {
        //       int productID = element.key;
        //       Product product = element.value;
        //       productList.add(product);
        //     });
        //
        //     return productList!
        //         .where((product) =>
        //             product.name.toLowerCase().contains(query.toString().trim()))
        //         .toList();
        //   },
        //   itemBuilder: (context, Product? product) {
        //     return ListTile(
        //       title: Text(product!.name),
        //     );
        //   },
        //   onSuggestionSelected: (Product? product) {
        //     print('Selected');
        //     textEditingController.text = product!.name;
        //     initiateSearch!(query: product.name);
        //   },
        //   textFieldConfiguration: TextFieldConfiguration(
        //       controller: textEditingController,
        //       decoration: InputDecoration(
        //         prefixIcon: Icon(Icons.search),
        //         hintText: 'Search items',
        //         fillColor: Colors.white,
        //         filled: true,
        //         border: InputBorder.none,
        //       )),
        // ),
        );
  }
}
