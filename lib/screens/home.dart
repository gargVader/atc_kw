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
  int q = 0;

  // Init State
  @override
  void initState() {
    super.initState();
    // Initialize SDK
    initSlangRetailAssistant();
    SearchUserJourney.disablePreserveContext();
    SlangRetailAssistant.getUI().showTrigger();
    // Fetch productList from JSON
    fetchAllProducts().then((productList) {
      setState(() {
        _productList = productList;
        _loading = false;
      });
    });
  }

  // Build func for Home screen
  @override
  Widget build(BuildContext context) {
    String colorFabIcon = "f0d765";
    String colorAccent = "f0851a";
    return Scaffold(
      appBar: customAppbar(context, "Home"),
      body: Column(
        children: [
          SearchBar(
            searchTerm: "",
            initiateSearch: initiateSearch,
            allProductList: _productList,
          ),
          _buildListView(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Container(
        child: FittedBox(
          child: Stack(
            alignment: Alignment(1.4, -1.5),
            children: [
              FloatingActionButton(
                // Your actual Fab
                onPressed: () {
                  setState(() {
                    q++;
                  });
                },
                child: Icon(Icons.shopping_cart),
                backgroundColor: Color(int.parse("0xff$colorFabIcon")),
              ),
              Container(
                // This is your Badge
                child: Center(
                  // Here you can put whatever content you want inside your Badge
                  child: Text('$q', style: TextStyle(color: Colors.white)),
                ),
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(minHeight: 32, minWidth: 32),
                decoration: BoxDecoration(
                  // This controls the shadow
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 5,
                        color: Colors.black.withAlpha(50))
                  ],
                  borderRadius: BorderRadius.circular(16),
                  color: Color(int.parse(
                      "0xff$colorAccent")), // This would be color of the Badge
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return (_productList == null)
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
                  return RetailItem((_productList as List<Product>)[index]);
                }),
          );
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

  // initiateSearch that is called from (home -> SearchPage)
  void initiateSearch({required String query, SearchInfo? searchInfo}) {
    List<Product> searchProductList = getSearchProductListFromQuery(query);
    if (searchProductList.length != 0) {
      Get.to(SearchPage(
        searchTerm: query,
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

    List<Product> searchProductList = getSearchProductListFromQuery(searchItem);
    if (searchProductList.length != 0) {
      Get.to(SearchPage.forSlang(
        searchProductList: searchProductList,
        allProductList: _productList,
        searchTerm: searchItem,
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
      ..assistantId = "bf08dee83833499d9556af7874634ed0"
      ..apiKey = "00aca65a68494054974680374b360fce";
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

  @override
  void onMicPermissionDenied() {
    // TODO: implement onMicPermissionDenied
  }
}
