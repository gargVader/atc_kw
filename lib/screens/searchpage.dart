import 'package:atc_kw/data.dart';
import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/widgets/customappbar.dart';
import 'package:atc_kw/widgets/dummySearchBar.dart';
import 'package:atc_kw/widgets/fab_cart.dart';
import 'package:atc_kw/widgets/retail_item.dart';
import 'package:flutter/material.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';

class SearchPage extends StatefulWidget {
  Map<int, Product>? searchProductMap;
  late final Map<int, Product>? allProductMap;
  String? searchTerm;
  SearchUserJourney? searchUserJourney;
  bool? isAddToCart;
  SearchInfo? searchInfo;

  SearchPage({
    this.searchTerm,
    this.isAddToCart,
    this.searchInfo,
    this.searchUserJourney,
  }) {
    allProductMap = Data.instance.allProductMap;
  }

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    implements RetailAssistantAction, RetailAssistantLifeCycleObserver {
  SearchInfo? searchQuery;

  @override
  void initState() {
    SlangRetailAssistant.setAction(this);
    // For query coming from Home
    initiateSearch(query: widget.searchTerm!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, "Search Items"),
      body: Column(
        children: [
          DummySearchBar(initiateSearch),
          // SearchBar(
          //   initiateSearch: initiateSearch,
          // ),
          _buildListView(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FabCart(),
    );
  }

  // Builds the listView that displays searchResults
  Widget _buildListView() {
    widget.searchProductMap =
        Data.instance.getSearchProducts(widget.searchTerm);
    // Generate List because it is required by the ListView to build RetailItem
    List<Product> searchProductList = [];
    widget.searchProductMap!.entries.forEach((element) {
      int productID = element.key;
      Product product = element.value;
      searchProductList.add(product);
    });

    if (widget.searchProductMap == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (widget.searchProductMap!.length == 0) {
      return Expanded(
        child: Center(
          child: Text('No matching items found'),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
            itemCount: widget.searchProductMap == null
                ? 0
                : widget.searchProductMap!.length,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              return RetailItem((searchProductList)[index]);
            }),
      );
    }
  }

  // Updates the searchTerm and searchProductMap
  void initiateSearch({required String query}) {
    // Search for the product
    Map<int, Product> searchProductMap = Data.instance.getSearchProducts(query);
    setState(() {
      print('Updating searchProductMap');
      widget.searchTerm = query;
      widget.searchProductMap = searchProductMap;
    });
    searchAction();
  }

  @override
  SearchAppState onSearch(
      SearchInfo searchInfo, SearchUserJourney searchUserJourney) {
    print('Search initiated for slang');
    String? searchItem = searchInfo.item?.description;
    String? itemSize = searchInfo.item?.size.toString();
    initiateSearch(query: searchItem!);
    searchAction();
    return SearchAppState.SEARCH_RESULTS;

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

  // Sets AppSate and AppStateCondition for Slang
  void searchAction() {
    if (widget.searchUserJourney == null) return;

    if (widget.searchProductMap == null) {
      setState(() {
        widget.searchUserJourney?.setFailure();
        widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
      });
    } else if (widget.searchProductMap!.length == 0) {
      setState(() {
        widget.searchUserJourney?.setItemNotFound();
        widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
      });
    } else {
      setState(() {
        widget.searchUserJourney?.setSuccess();
        widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
      });
    }

    // if (widget.isAddToCart == false) {
    //   widget.searchUserJourney?.setSuccess();
    //   widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    // } else {
    //   print('Add to cart');
    //   widget.searchUserJourney?.setSuccess();
    //   widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    //   // addToCartFlow();
    // }
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

  addToCartFlow() {
    // Map productQtyMap = CartBloc.instance.cartItems.value;
    // Map<int, Product>? sea = this.widget.searchProductMap;
    // String? searchItem = widget.searchInfo!.item?.description;
    // String? itemSize = widget.searchInfo!.item?.size.toString();
    //
    // if (widget.isAddToCart == true && productQtyMap.length == 1) {
    //   CartBloc.instance.addToCart()
    //   // cartbloc.addToCart(widget.productList[0]);
    //   widget.searchUserJourney?.setSuccess();
    //   widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    // } else if (widget.isAddToCart == true && productQtyMap.length > 1) {
    //   widget.searchUserJourney?.setNeedDisambiguation();
    //   widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    // } else {
    //   widget.searchUserJourney?.setFailure();
    //   widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    // }
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

// Search function for SearchPage used by Slang
// Searches for query and updates searchProductMap
// void initiateSearchForSlang(Map<int, Product>? allProductMap,
//     SearchInfo? searchInfo, SearchUserJourney searchUserJourney) {
//   print('Search initiated for slang');
//   String? searchItem = searchInfo!.item?.description;
//   String? itemSize = searchInfo.item?.size.toString();
//
//   Map<int, Product> searchProductMap = new Map();
//   widget.allProductMap!.entries.forEach((element) {
//     int productID = element.key;
//     Product product = element.value;
//     if (product.name
//         .toLowerCase()
//         .contains(searchItem!.toLowerCase().trim())) {
//       searchProductMap[productID] = product;
//     }
//   });
//   print('Setting app state');
//   setState(() {
//     widget.searchProductMap = searchProductMap;
//     if (searchProductMap.length == 0) {
//       itemNotFound();
//     } else {
//       widget.searchUserJourney?.setSuccess();
//       widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
//     }
//   });
// }
}
