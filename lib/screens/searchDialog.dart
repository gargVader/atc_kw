import 'package:atc_kw/data.dart';
import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/widgets/customappbar.dart';
import 'package:atc_kw/widgets/dummySearchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchDialog extends StatefulWidget {
  // Function
  Function? initiateSearch;
  late List<String> productNameList;

  // Map<int, Product>? allProductMap = Data.instance.allProductMap;
  SearchBarOnItemClickListener? onItemClickListener;
  DummySearchBar dummySearchBar;
  bool isLinearProgressBarActive = true;
  TextEditingController controller = TextEditingController();

  SearchDialog(this.initiateSearch, this.dummySearchBar) {
    // productNameList = generateProductNameList(allProductMap, 50);
  }

  @override
  _SearchDialogState createState() => _SearchDialogState();

  void setOnItemClickListener(
      SearchBarOnItemClickListener onItemClickListener) {
    this.onItemClickListener = onItemClickListener;
  }

  List<String> generateProductNameList(
      Map<int, Product>? productMap, int limit) {
    Set<String> nameSet = Set();
    int i = 0;
    for (MapEntry element in productMap!.entries) {
      int productId = element.key;
      Product product = element.value;
      nameSet.add(product.name);
      if (i > limit) break;
      i++;
    }
    return nameSet.toList();
  }
}

class _SearchDialogState extends State<SearchDialog> {

  @override
  void initState() {
    super.initState();
    initProductNameList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, "Search Grocery items"),
      body: Column(
        children: [
          // Search Bar
          Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(15),
              child: TextField(
                autofocus: true,
                controller: widget.controller,
                onChanged: (String text) {
                  notifyTextChanges(text);
                },
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
                  searchAction(text);
                },
              )),

          // SearchBar(
          //   initiateSearch: widget.initiateSearch,
          //   searchDialog: widget,
          // ),

          // ListView for products
          _buildListView(),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return (widget.isLinearProgressBarActive)
        ? LinearProgressIndicator()
        : Expanded(
            child: ListView.builder(
                itemCount: widget.productNameList.length,
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      searchAction(widget.productNameList[index]);
                    },
                    title: Text(widget.productNameList[index]),
                  );
                }),
          );
  }

  void searchAction(String searchTerm) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
    widget.onItemClickListener!.onSearchItemClick(searchTerm);
    setState(() {
      // widget.dummySearchBar.displayTerm = searchTerm;
    });
  }

  void initProductNameList(){
    notifyTextChanges("");
  }

  void notifyTextChanges(String text) {
    setState(() {
      widget.isLinearProgressBarActive = true;
    });
    // if ((text.trim()).isEmpty) {
    //   setState(() {
    //     widget.productNameList =
    //         widget.generateProductNameList(widget.allProductMap, 50);
    //   });
    //   return;
    // }
    Data.instance.getSearchProducts(text).then((value) {
      Map<int, Product> searchProductMap = value;
      List<String> productNameList = widget.generateProductNameList(
          searchProductMap, searchProductMap.length);
      setState(() {
        widget.productNameList = productNameList;
        widget.isLinearProgressBarActive = false;
      });
    });
  }
}

class SearchBarOnItemClickListener {
  void onSearchItemClick(String searchTerm) {}
}
