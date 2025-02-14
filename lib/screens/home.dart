import 'package:atc_kw/data.dart';
import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/screens/searchpage.dart';
import 'package:atc_kw/widgets/customappbar.dart';
import 'package:atc_kw/widgets/dummySearchBar.dart';
import 'package:atc_kw/widgets/fab_cart.dart';
import 'package:atc_kw/widgets/retail_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';

import '../main.dart';

// HomePage
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
  SearchUserJourney? _searchUserJourney;
  Map<int, Pair<Product, double>>? _productMap;

  // List of products to be generated later
  late List<Product> _productList;

  // Boolean to signify loading of items in homepage
  bool _loading = true;

  // Init State
  @override
  void initState() {
    super.initState();
    // Initialize SDK
    initSlangRetailAssistant();
    SearchUserJourney.disablePreserveContext();
    SlangRetailAssistant.getUI().showTrigger();

    // Fetch productMap from JSON if not already cached.
    if (Data.instance.allProductMap != null) {
      _productMap = Data.instance.allProductMap;
      _productList = generateProductListFromProductMap(_productMap);
      _loading = false;
    } else {
      Data.instance.getAllProducts().then((productMap) => setState(() {
            _productMap = productMap;
            _productList = generateProductListFromProductMap(_productMap);
            _loading = false;
          }));
    }
  }

  // Build func for Home screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, "Home"),
      body: Column(
        children: [
          // Search Bar
          DummySearchBar(initiateSearch),
          // SearchBar(
          //   initiateSearch: initiateSearch,
          // ),
          // ListView for products
          _buildListView(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FabCart(),
    );
  }

  List<Product> generateProductListFromProductMap(
      Map<int, Pair<Product, double>>? productMap) {
    List<Product> productList = [];
    _productMap!.entries.forEach((element) {
      int productId = element.key;
      Product product = element.value.product;
      productList.add(product);
    });
    return productList;
  }

  Widget _buildListView() {
    return (_productMap == null)
        ? Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Expanded(
            child: ListView.builder(
                itemCount: _productMap == null ? 0 : _productMap!.length,
                padding: EdgeInsets.only(left: 12, right: 12, top: 10),
                itemBuilder: (context, index) {
                  return RetailItem(_productList[index]);
                }),
          );
  }

  void initiateSearch({required String query}) {
    print('initiate search method called from Home');
    Get.to(SearchPage(
      searchTerm: query,
    ));
  }

  // Triggered by Slang
  @override
  SearchAppState onSearch(
      SearchInfo searchInfo, SearchUserJourney searchUserJourney) {
    _searchUserJourney = searchUserJourney;
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

    // Initiate search for Slang
    Get.to(SearchPage(
      searchTerm: searchItem,
      searchUserJourney: searchUserJourney,
      searchInfo: searchInfo,
      isAddToCart: searchInfo.isAddToCart,
    ));
    return SearchAppState.WAITING;
  }

  void initSlangRetailAssistant() {
    AssistantUIPosition assistantUIPosition = new AssistantUIPosition();
    assistantUIPosition.isDraggable = true;
    var assistantConfig = new AssistantConfiguration()
      ..assistantId = "bf08dee83833499d9556af7874634ed0"
      ..apiKey = "00aca65a68494054974680374b360fce"
      ..uiPosition = assistantUIPosition;

    SlangRetailAssistant.initialize(assistantConfig);
    SlangRetailAssistant.setAction(this);
    SlangRetailAssistant.setLifecycleObserver(this);
  }

  // bool? searchforItem(String? searchItem) {
  //   for (int i = 0; i < items.length; i++) {
  //     return items[i]['name'].toString().toLowerCase() ==
  //         (searchItem.toString().trim());
  //   }
  // }

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
