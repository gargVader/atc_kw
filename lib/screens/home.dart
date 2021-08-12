import 'dart:convert';

import 'package:atc_kw/models/Product.dart';
import 'package:atc_kw/screens/items.dart';
import 'package:atc_kw/screens/searchpage.dart';
import 'package:atc_kw/widgets/customappbar.dart';
import 'package:atc_kw/widgets/retail_item.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    initSlangRetailAssistant();
    SearchUserJourney.disablePreserveContext();
    SlangRetailAssistant.getUI().showTrigger();
  }

  bool? searchforItem(String? searchItem) {
    for (int i = 0; i < items.length; i++) {
      return items[i]['name'].toString().toLowerCase() ==
          (searchItem.toString().trim());
    }
  }

  @override
  SearchAppState onSearch(
      SearchInfo searchInfo, SearchUserJourney searchUserJourney) {
    _searchUserJourney = searchUserJourney;
    String? searchItem = searchInfo.item?.description;
    String? itemSize = searchInfo.item?.size.toString();
    // print("Size = $itemSize");
    List itemList = items
        .where((item) => item['name']
            .toString()
            .toLowerCase()
            .contains(searchItem.toString().trim()))
        .toList();
    if (itemSize!.contains("kg")) {
      itemList = itemList
          .where((item) =>
              item['quantity'].toString().toLowerCase().contains(itemSize))
          .toList();
    }
    if (itemList.length != 0) {
      Get.to(SearchPage(
        itemList: itemList,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context),
        body: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString('assets/list.json'),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            var itemList = json.decode(snapshot.data.toString());
            return ListView.builder(
                itemCount: itemList == null ? 0 : itemList.length,
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  return RetailItem(getProduct(itemList[index]));
                });
          },
        ));
  }

  Product getProduct(var productMap) {
    final int id = productMap['id'];
    final String name = productMap['name'];
    final String synonyms = productMap['synonyms'];
    final String brand = productMap['brand'];
    final double price = double.parse((productMap['price']).toString());
    final int sizeInt = productMap['sizeInt'];
    final String size = productMap['size'];
    final String unit = productMap['unit'];
    final String imageUrl = productMap['imageUrl'];
    return Product(
        id, name, synonyms, brand, price, sizeInt, size, unit, imageUrl);
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

// Future<void> searchItem() {}
}
