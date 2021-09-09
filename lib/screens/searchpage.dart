import 'package:atc_kw/data.dart';
import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/widgets/customappbar.dart';
import 'package:atc_kw/widgets/dummySearchBar.dart';
import 'package:atc_kw/widgets/fab_cart.dart';
import 'package:atc_kw/widgets/retail_item.dart';
import 'package:flutter/material.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';

import '../cart_bloc.dart';

class SearchPage extends StatefulWidget {
  Map<int, Pair<Product, double>>? searchProductMap;

  // late final Map<int, Product>? allProductMap;
  String? searchTerm;
  SearchUserJourney? searchUserJourney;
  bool? isAddToCart;
  SearchInfo? searchInfo;
  bool isCircularProgressActive = true;
  List<Product> searchProductList = [];

  SearchPage({
    this.searchTerm,
    this.isAddToCart, // Slang specific
    this.searchInfo, // Slang specific
    this.searchUserJourney, // Slang specific
  }) {
    // allProductMap = Data.instance.allProductMap;
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
          DummySearchBar(initiateSearch, displayTerm: widget.searchTerm),
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
    // setState(() {
    //   widget.isCircularProgressActive = true;
    // });
    //
    // Data.instance.getSearchProducts(widget.searchTerm).then((value) {
    //   Map<int, Product> searchProductMap = value;
    //   // Generate List because it is required by the ListView to build RetailItem
    //   List<Product> searchProductList = [];
    //   searchProductMap.entries.forEach((element) {
    //     int productID = element.key;
    //     Product product = element.value;
    //     searchProductList.add(product);
    //   });
    //
    //   setState(() {
    //     widget.searchProductList = searchProductList;
    //     widget.isCircularProgressActive = false;
    //   });
    // });

    if (widget.isCircularProgressActive) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (widget.searchProductList.length == 0) {
      return Expanded(
        child: Center(
          child: Text('No matching items found'),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
            itemCount: widget.searchProductList.length,
            padding: EdgeInsets.only(left: 12, right: 12, top: 10),
            itemBuilder: (context, index) {
              return RetailItem((widget.searchProductList)[index]);
            }),
      );
    }
  }

  // Updates the searchTerm and searchProductMap
  void initiateSearch({required String query}) {
    // Search for the product

    // Data.instance.getSearchProducts(query).then((value) {
    //   Map<int, Product> searchProductMap = value;
    //   setState(() {
    //     print('Updating searchProductMap');
    //     widget.searchTerm = query;
    //     widget.searchProductMap = searchProductMap;
    //   });
    // });

    print('initiating search for searchPage');
    setState(() {
      widget.isCircularProgressActive = true;
      widget.searchTerm = query;
    });

    Data.instance.getSearchProducts(widget.searchTerm).then((value) {
      Map<int, Pair<Product, double>> searchProductMap = value;
      // Generate List because it is required by the ListView to build RetailItem
      List<Product> searchProductList = [];
      searchProductMap.entries.forEach((element) {
        int productID = element.key;
        Product product = element.value.product;
        searchProductList.add(product);
      });

      setState(() {
        widget.searchProductList = searchProductList;
        widget.searchProductMap = searchProductMap;
        print('isCircularProgressActive=false');
        widget.isCircularProgressActive = false;
      });
      searchAction();
    });
  }

  @override
  SearchAppState onSearch(
      SearchInfo searchInfo, SearchUserJourney searchUserJourney) {
    setState(() {
      widget.searchUserJourney = searchUserJourney;
      widget.searchInfo = searchInfo;
      widget.isAddToCart = searchInfo.isAddToCart;
    });

    String? searchItem = searchInfo.item?.description;
    String? searchSize = searchInfo.item?.size.toString();
    String? searchBrand = searchInfo.item?.brand.toString();

    print('Search initiated for slang');

    if (searchSize != "null") {
      searchItem = searchItem! + " " + searchSize!;
    }

    if (searchBrand != "null") {
      searchItem = searchItem! + " " + searchBrand!;
    }

    initiateSearch(query: searchItem!);
    // searchAction();
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

  // Sets AppSate and AppStateCondition for Slang
  void searchAction() {
    if (widget.searchUserJourney == null) return;

    // if (widget.searchProductList == null) {
    //   setState(() {
    //     widget.searchUserJourney?.setFailure();
    //     widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    //   });
    // } else if (widget.searchProductList.length == 0) {
    //   setState(() {
    //     widget.searchUserJourney?.setItemNotFound();
    //     widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    //   });
    // } else {
    //   setState(() {
    //     widget.searchUserJourney?.setSuccess();
    //     widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    //   });
    // }

    if (widget.isAddToCart != null && widget.isAddToCart == true) {
    // if (false) {
      print('isAddToCart');
      if (widget.searchProductList.length == 1) {
        CartBloc.instance.addToCart(widget.searchProductList[0].id);
        widget.searchUserJourney?.setSuccess();
        widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
      } else if (widget.searchProductMap!.length > 1) {
        // Multiple items exist
        // Loop through the map
        // Find the set of top products

        Pair<Product, double> p = widget.searchProductMap!.values.elementAt(0);
        double mxScore = p.score;
        Product product = p.product;
        int count = 0; // count of mxScore in my searchResults

        for (var val in widget.searchProductMap!.values) {
          double curr_score = val.score;
          Product product = val.product;
          if (curr_score != mxScore) {
            break;
          } else {
            count++;
          }
        }

        if (count > 3) {
          // Require disambiguation
          widget.searchUserJourney?.setNeedDisambiguation();
          widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
        } else if (count == 3) {
          // I know the product, but I donot know the size
          widget.searchUserJourney?.setNeedItemQuantity();
          widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
        } else if (count == 1) {
          // I definitely know
          CartBloc.instance.addToCart(widget.searchProductList[0].id);
          widget.searchUserJourney?.setSuccess();
          widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
        } else {
          widget.searchUserJourney?.setNeedDisambiguation();
          widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
        }
      }
    } else {
      if (widget.searchProductList == null) {
        setState(() {
          widget.searchUserJourney?.setFailure();
          widget.searchUserJourney
              ?.notifyAppState(SearchAppState.SEARCH_RESULTS);
        });
      } else if (widget.searchProductList.length == 0) {
        setState(() {
          widget.searchUserJourney?.setItemNotFound();
          widget.searchUserJourney
              ?.notifyAppState(SearchAppState.SEARCH_RESULTS);
        });
      } else {
        setState(() {
          widget.searchUserJourney?.setSuccess();
          widget.searchUserJourney
              ?.notifyAppState(SearchAppState.SEARCH_RESULTS);
        });
      }
    }

    // if (true) {
    //   if (widget.searchProductList == null) {
    //     setState(() {
    //       widget.searchUserJourney?.setFailure();
    //       widget.searchUserJourney
    //           ?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    //     });
    //   } else if (widget.searchProductList.length == 0) {
    //     setState(() {
    //       widget.searchUserJourney?.setItemNotFound();
    //       widget.searchUserJourney
    //           ?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    //     });
    //   } else {
    //     setState(() {
    //       widget.searchUserJourney?.setSuccess();
    //       widget.searchUserJourney
    //           ?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    //     });
    //   }
    // } else {
    //   print('Add to cart');
    //   if (widget.searchProductList.length == 1) {
    //     CartBloc.instance.addToCart(widget.searchProductList[0]);
    //     widget.searchUserJourney?.setSuccess();
    //     widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    //   } else if (widget.searchProductList.length > 1) {
    //     widget.searchUserJourney?.setNeedDisambiguation();
    //     widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    //   } else {
    //     widget.searchUserJourney?.setFailure();
    //     widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    //   }
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
