import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/widgets/customappbar.dart';
import 'package:atc_kw/widgets/retail_item.dart';
import 'package:atc_kw/widgets/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';

class SearchPage extends StatefulWidget {
  List<Product>? searchProductList;
  final List<Product>? allProductList;
  String? searchTerm;
  SearchUserJourney? searchUserJourney;
  bool? isAddToCart;
  SearchInfo? searchInfo;

  SearchPage.forSlang({
    Key? key,
    this.searchProductList,
    this.allProductList,
    this.searchTerm,
    this.isAddToCart,
    this.searchInfo,
    this.searchUserJourney,
  }) : super(key: key);

  SearchPage({
    Key? key,
    this.searchTerm,
    this.searchProductList,
    this.allProductList,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    implements RetailAssistantAction, RetailAssistantLifeCycleObserver {
  SearchInfo? searchQuery;

  void searchAction() {
    if (widget.searchUserJourney == null) return;
    if (widget.isAddToCart == false) {
      widget.searchUserJourney?.setSuccess();
      widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    } else {
      addToCartFlow();
    }
  }

  addToCartFlow() {
    // if (widget.isAddToCart == true && widget.productList!.length == 1) {
    //   cartbloc.addToCart(widget.productList[0]);
    //   widget.searchUserJourney?.setSuccess();
    //   widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    // } else if (widget.isAddToCart == true && widget.productList!.length > 1) {
    //   widget.searchUserJourney?.setNeedDisambiguation();
    //   widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    // } else {
    //   widget.searchUserJourney?.setFailure();
    //   widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    // }
  }

  @override
  void initState() {
    searchAction();
    SlangRetailAssistant.setAction(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context, "Search Items"),
        body: Column(
          children: [
            SearchBar(
              initiateSearch: initiateSearch,
              allProductList: widget.allProductList,
              searchTerm: widget.searchTerm,
            ),
            (widget.searchProductList == null)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: widget.searchProductList == null
                            ? 0
                            : (widget.searchProductList as List<Product>)
                                .length,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        itemBuilder: (context, index) {
                          return RetailItem(widget.searchProductList![index]);
                        }),
                  ),
          ],
        )

        // ListView.builder(
        //     itemCount: widget.productList?.length,
        //     padding: EdgeInsets.symmetric(horizontal: 12),
        //     itemBuilder: (context, index) {
        //       return Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 4),
        //         child: ListTile(
        //           tileColor: Colors.grey[200],
        //           contentPadding: EdgeInsets.all(10),
        //           minVerticalPadding: 4,
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(5)),
        //           key: Key(index.toString()),
        //           leading: Icon(
        //             Icons.store,
        //             color: Colors.black,
        //           ),
        //           title: Text(
        //             widget.productList![index].name,
        //             style: TextStyle(fontWeight: FontWeight.bold),
        //           ),
        //           subtitle: Text(
        //             "${widget.productList![index].sizeInt} ${widget.productList![index].unit.toUpperCase()}, ${widget.productList![index].price}",
        //           ),
        //           trailing: IconButton(
        //               onPressed: () {
        //                 cartbloc.addToCart(widget.productList![index]);
        //                 print(cartbloc.cartItems.value);
        //               },
        //               icon: Icon(Icons.shopping_cart)),
        //         ),
        //       );
        //     }),
        );
  }

  // manyItemsDetected(List<Product>? productList, SearchInfo? searchInfo) {
  //   String? searchItem = searchInfo!.item?.description;
  //   String? itemSize = searchInfo.item?.size.toString();
  //   List<Product> searchProductList = (productList as List<Product>)
  //       .where((product) =>
  //           product.name.toLowerCase().contains(searchItem.toString().trim()))
  //       .toList();
  //   if (itemSize!.contains("kg")) {
  //     searchProductList = searchProductList
  //         .where((product) =>
  //             product.size.toLowerCase().contains(itemSize))
  //         .toList();
  //   }
  //   return searchProductList;
  //
  //   // String sizeString = searchInfo!.item!.size.toString();
  //   // List<Product> searchProductListFromExisting = productList!
  //   //     .where((product) => product.size.toLowerCase().contains(sizeString))
  //   //     .toList();
  //   // return searchProductListFromExisting;
  // }

  void initiateSearch({required String query}) {
    List<Product> searchProductList = (widget.allProductList as List<Product>)
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase().trim()))
        .toList();
    setState(() {
      widget.searchProductList = searchProductList;
    });
  }

  void searchForProductsAndUpdateList(List<Product>? productList,
      SearchInfo? searchInfo, SearchUserJourney searchUserJourney) {
    String? searchItem = searchInfo!.item?.description;
    String? itemSize = searchInfo.item?.size.toString();

    List<Product> searchProductList = (productList as List<Product>)
        .where((product) =>
            product.name.toLowerCase().contains(searchItem.toString().trim()))
        .toList();
    if (itemSize!.contains("kg")) {
      searchProductList = searchProductList
          .where((product) => product.size.toLowerCase().contains(itemSize))
          .toList();
    }
    setState(() {
      widget.searchProductList = searchProductList;
      widget.searchUserJourney?.setSuccess();
      widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    });
  }

  @override
  SearchAppState onSearch(
      SearchInfo searchInfo, SearchUserJourney searchUserJourney) {
    searchForProductsAndUpdateList(
        widget.allProductList, searchInfo, searchUserJourney);
    return SearchAppState.WAITING;

    // print(searchInfo.item?.description);
    // var items = manyItemsDetected(widget.allProductList, searchInfo);
    // if (items.length >= 1) {
    //   cartbloc.addToCart(items[0]);
    //   searchUserJourney.setSuccess();
    // } else {
    //   searchUserJourney.setItemNotFound();
    // }
    // return SearchAppState.ADD_TO_CART;
  }

  @override
  void onAssistantClosed(bool isCancelled) {
    // TODO: implement onAssistantClosed
  }

  @override
  void onAssistantError(Map<String, String> assistantError) {
    // TODO: implement onAssistantError
  }

  @override
  void onAssistantInitFailure(String description) {
    // TODO: implement onAssistantInitFailure
  }

  @override
  void onAssistantInitSuccess() {
    // TODO: implement onAssistantInitSuccess
  }

  @override
  void onAssistantInvoked() {
    // TODO: implement onAssistantInvoked
  }

  @override
  void onAssistantLocaleChanged(Map<String, String> locale) {
    // TODO: implement onAssistantLocaleChanged
  }

  @override
  void onOnboardingFailure() {
    // TODO: implement onOnboardingFailure
  }

  @override
  void onOnboardingSuccess() {
    // TODO: implement onOnboardingSuccess
  }

  @override
  void onUnrecognisedUtterance(String utterance) {
    // TODO: implement onUnrecognisedUtterance
  }

  @override
  void onUtteranceDetected(String utterance) {
    // TODO: implement onUtteranceDetected
  }

  @override
  void onMicPermissionDenied() {
    // TODO: implement onMicPermissionDenied
  }
}
