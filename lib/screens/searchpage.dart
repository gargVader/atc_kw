import 'package:atc_kw/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';
import 'package:atc_kw/screens/items.dart';
import '../cart_bloc.dart';

class SearchPage extends StatefulWidget {
  final String? searchItem;
  final SearchUserJourney? searchUserJourney;
  SearchPage({
    Key? key,
    this.searchItem,
    this.searchUserJourney,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    implements RetailAssistantAction, RetailAssistantLifeCycleObserver {
  List<Map<String, dynamic>> searchItems = [];

  void searchforItem() {
    setState(() {
      searchItems = items
          .where((item) => item['name']
              .toString()
              .toLowerCase()
              .contains(widget.searchItem.toString()))
          .toList();
    });
    print(searchItems);
    widget.searchUserJourney?.setItemNotSpecified();
    widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
  }

  searchItemSpecific(String? quantity) {
    var item = items
        .where((element) => element['quantity']
            .toString()
            .toLowerCase()
            .contains(quantity.toString()))
        .toList()[0];
    if (item.length != 0) {
      cartbloc.addToCart(item);
      widget.searchUserJourney?.setSuccess();
      widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    } else {
      widget.searchUserJourney?.setItemNotFound();
      widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    }
  }

  @override
  void initState() {
    searchforItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context),
      body: ListView.builder(
          itemCount: searchItems.length,
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
                  searchItems[index]['name'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${searchItems[index]['quantity'].toString()}, ${searchItems[index]['price'].toString()}",
                ),
                trailing: IconButton(
                    onPressed: () {
                      cartbloc.addToCart(searchItems[index]);
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
  SearchAppState onSearch(
      SearchInfo searchInfo, SearchUserJourney searchUserJourney) {
    return searchItemSpecific(searchInfo.item?.quantity.toString());
  }

  @override
  void onUnrecognisedUtterance(String utterance) {
    // TODO: implement onUnrecognisedUtterance
  }

  @override
  void onUtteranceDetected(String utterance) {
    // TODO: implement onUtteranceDetected
  }
}
