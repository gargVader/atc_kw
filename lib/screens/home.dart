import 'dart:convert';

import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/screens/items.dart';
import 'package:atc_kw/screens/searchpage.dart';
import 'package:atc_kw/widgets/customappbar.dart';
import 'package:atc_kw/widgets/retail_item.dart';
import 'package:atc_kw/widgets/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';

import '../main.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    implements
        RetailAssistantAction,
        RetailAssistantLifeCycleObserver,
        RouteAware {
  String _searchText = '';
  SearchUserJourney? _searchUserJourney;
  List<Product>? _productList;
  bool _loading = true;

  // Init State
  @override
  void initState() {
    super.initState();
    initSlangRetailAssistant();
    SearchUserJourney.disablePreserveContext();
    SlangRetailAssistant.getUI().showTrigger();
    _loading = true;
    fetchAllProducts().then((productList) {
      setState(() {
        _productList = productList;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context, "Home"),
        body: Column(
          children: [
            SearchBar(
                initiateSearch: initiateSearch, productList: _productList),
            (_productList == null)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: _productList == null
                            ? 0
                            : (_productList as List<Product>).length,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        itemBuilder: (context, index) {
                          return RetailItem(
                              (_productList as List<Product>)[index]);
                        }),
                  ),
          ],
        ));
  }

  // Method to fetch all products from json
  Future<List<Product>> fetchAllProducts() async {
    String response = await rootBundle.loadString('assets/list.json');
    var products = await json.decode(response);
    List<Product> productList = [];
    for (var product in products) {
      productList.add(Product.fromJson(product));
    }
    return productList;
  }

  void initiateSearch({required String query, SearchInfo? searchInfo}) {
    List<Product> searchProductList = getSearchProductListFromQuery(query);
    if (searchProductList.length != 0) {
      Get.to(SearchPage(
        searchProductList: searchProductList,
        allProductList: _productList,
      ));
    } else {
      itemNotFound();
    }
  }

  List<Product> getSearchProductListFromQuery(String? query) {
    return (_productList as List<Product>)
        .where((product) =>
            product.name.toLowerCase().contains(query!.toLowerCase().trim()))
        .toList();
  }

  @override
  SearchAppState onSearch(
      SearchInfo searchInfo, SearchUserJourney searchUserJourney) {
    _searchUserJourney = searchUserJourney;
    String? searchItem = searchInfo.item?.description;
    String? itemSize = searchInfo.item?.size.toString();

    List<Product> searchProductList = (_productList as List<Product>)
        .where((product) =>
            product.name.toLowerCase().contains(searchItem.toString().trim()))
        .toList();
    if (itemSize!.contains("kg")) {
      searchProductList = searchProductList
          .where((product) => product.size.toLowerCase().contains(itemSize))
          .toList();
    }
    if (searchProductList.length != 0) {
      Get.to(SearchPage.forSlang(
        searchProductList: searchProductList,
        allProductList: _productList,
        searchUserJourney: searchUserJourney,
        searchInfo: searchInfo,
        isAddToCart: searchInfo.isAddToCart,
      ));
    } else {
      itemNotFound();
    }
    return SearchAppState.WAITING;
  }

  void initSlangRetailAssistant() {
    var assistantConfig = new AssistantConfiguration()
      ..assistantId = "f2a7015638314b028792d1c09ef49440"
      ..apiKey = "efde0494c7e643dbbcca64b967cbd8d4";
    SlangRetailAssistant.initialize(assistantConfig);
    SlangRetailAssistant.setAction(this);
    SlangRetailAssistant.setLifecycleObserver(this);
  }

  bool? searchforItem(String? searchItem) {
    for (int i = 0; i < items.length; i++) {
      return items[i]['name'].toString().toLowerCase() ==
          (searchItem.toString().trim());
    }
  }

  @override
  void onAssistantClosed(bool isCancelled) {
    print("onAssistantClosed " + isCancelled.toString());
  }

  @override
  void onAssistantInitFailure(String description) {
    print("onAssistantInitFailure " + description);
  }

  @override
  void onAssistantInitSuccess() {
    print("onAssistantInitSuccess");
  }

  @override
  void onAssistantInvoked() {
    // SearchUserJourney.getContext().clear();
    print("onAssistantInvoked");
  }

  @override
  void onAssistantLocaleChanged(Map<String, String> locale) {
    print("onAssistantLocaleChanged " + locale.toString());
  }

  @override
  void onOnboardingFailure() {
    print("onOnboardingFailure");
  }

  @override
  void onOnboardingSuccess() {
    print("onOnboardingSuccess");
  }

  @override
  void onUnrecognisedUtterance(String utterance) {
    print("onUnrecognisedUtterance " + utterance);
  }

  @override
  void onUtteranceDetected(String utterance) {
    print("onUtteranceDetected " + utterance);
  }

  @override
  void onAssistantError(Map<String, String> assistantError) {
    print("AssistantError " + assistantError.toString());
  }

  Future<void> itemNotFound() async {
    _searchUserJourney?.setItemNotFound();
    _searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPop() {
    // TODO: implement didPop
  }

  @override
  void didPush() {
    // TODO: implement didPush
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    SlangRetailAssistant.setAction(this);
  }
}
