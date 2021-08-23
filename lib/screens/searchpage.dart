import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/widgets/customappbar.dart';
import 'package:atc_kw/widgets/fab_cart.dart';
import 'package:atc_kw/widgets/retail_item.dart';
import 'package:atc_kw/widgets/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';

class SearchPage extends StatefulWidget {
  Map<int, Product>? searchProductMap;
  final Map<int, Product>? allProductMap;
  String? searchTerm;
  SearchUserJourney? searchUserJourney;
  bool? isAddToCart;
  SearchInfo? searchInfo;

  SearchPage.forSlang({
    Key? key,
    this.searchTerm,
    this.searchProductMap,
    this.allProductMap,
    this.isAddToCart,
    this.searchInfo,
    this.searchUserJourney,
  }) : super(key: key);

  SearchPage({
    Key? key,
    this.searchTerm,
    this.searchProductMap,
    this.allProductMap,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    implements RetailAssistantAction, RetailAssistantLifeCycleObserver {
  SearchInfo? searchQuery;

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
            allProductMap: widget.allProductMap,
          ),
          _buildListView(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FabCart(),
    );
  }

  // Builds the listView that displays searchResults
  Widget _buildListView() {
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

  // Search function for SearchPage
  // Searches for query and updates searchProductMap
  void initiateSearch({required String query}) {
    // List<Product> searchProductList = (widget.allProductMap as List<Product>)
    //     .where((product) =>
    //         product.name.toLowerCase().contains(query.toLowerCase().trim()))
    //     .toList();
    // Search for the product
    Map<int, Product> searchProductMap = new Map();
    widget.allProductMap!.entries.forEach((element) {
      int productID = element.key;
      Product product = element.value;
      if (product.name.toLowerCase().contains(query.toLowerCase().trim())) {
        searchProductMap[productID] = product;
      }
    });

    setState(() {
      widget.searchProductMap = searchProductMap;
    });
  }

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

  @override
  SearchAppState onSearch(
      SearchInfo searchInfo, SearchUserJourney searchUserJourney) {
    print('Search initiated for slang');
    String? searchItem = searchInfo.item?.description;
    String? itemSize = searchInfo.item?.size.toString();

    initiateSearch(query: searchItem!);
    print('Setting app state');

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

    // initiateSearchForSlang(widget.allProductMap, searchInfo, searchUserJourney);
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

  Future<void> itemNotFound() async {
    widget.searchUserJourney?.setItemNotFound();
    widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
  }

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
