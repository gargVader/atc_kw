import 'dart:convert';

import 'package:atc_kw/cart_bloc.dart';
import 'package:atc_kw/screens/cart.dart';
import 'package:atc_kw/screens/items.dart';
import 'package:atc_kw/screens/searchpage.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    implements RetailAssistantAction, RetailAssistantLifeCycleObserver {
  String _searchText = '';
  SearchUserJourney? _searchUserJourney;

  @override
  void initState() {
    super.initState();
    initSlangRetailAssistant();
    SlangRetailAssistant.getUI().showTrigger();
  }

  @override
  SearchAppState onSearch(
      SearchInfo searchInfo, SearchUserJourney searchUserJourney) {
    String? searchItem = searchInfo.item?.description;
    print(searchItem);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(
            searchItem: searchItem,
          ),
        ));
    searchUserJourney.setSuccess();
    return SearchAppState.SEARCH_RESULTS;
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
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cart(),
                    ));
              },
              icon: StreamBuilder<Object>(
                  stream: cartbloc.cartItems,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Badge(
                        badgeContent: Text(
                          snapshot.data.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                        ),
                      );
                    }
                    return Badge(
                      badgeContent: Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                      ),
                    );
                  }))
        ],
      ),
      body: ListView.builder(
          itemCount: items.length,
          padding: EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                tileColor: Colors.grey[200],
                contentPadding: EdgeInsets.all(10),
                minVerticalPadding: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                key: Key(index.toString()),
                leading: Icon(
                  Icons.store,
                  color: Colors.black,
                ),
                title: Text(
                  items[index]['name'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${items[index]['quantity'].toString()}, ${items[index]['price'].toString()}",
                ),
                trailing: IconButton(
                    onPressed: () {
                      cartbloc.addToCart(items[index]);
                      print(cartbloc.cartItems.value);
                    },
                    icon: Icon(Icons.shopping_cart)),
              ),
            );
          }),
    );
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
}
