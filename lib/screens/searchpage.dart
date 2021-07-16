import 'package:atc_kw/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';
import 'package:atc_kw/screens/items.dart';
import '../cart_bloc.dart';

class SearchPage extends StatefulWidget {
  final List? itemList;
  final SearchUserJourney? searchUserJourney;
  bool? isAddToCart;
  final SearchInfo? searchInfo;
  SearchPage({
    Key? key,
    this.itemList,
    this.isAddToCart,
    this.searchInfo,
    this.searchUserJourney,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    implements RetailAssistantAction, RetailAssistantLifeCycleObserver {
  SearchInfo? searchQuery;
  void searchAction() {
    if (widget.isAddToCart == false) {
      widget.searchUserJourney?.setSuccess();
      widget.searchUserJourney?.notifyAppState(SearchAppState.SEARCH_RESULTS);
    } else {
      addToCartFlow();
    }
  }

  addToCartFlow() {
    if (widget.isAddToCart == true && widget.itemList!.length == 1) {
      cartbloc.addToCart(widget.itemList![0]);
      widget.searchUserJourney?.setSuccess();
      widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    } else if (widget.isAddToCart == true && widget.itemList!.length > 1) {
      widget.searchUserJourney?.setNeedDisambiguation();
      widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
      if (searchQuery != null) {
        widget.searchUserJourney?.setSuccess();
        widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
      } else {
        widget.searchUserJourney?.setFailure();
        // widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
      }
    } else {
      widget.searchUserJourney?.setFailure();
      widget.searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
    }
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
      appBar: customAppbar(context),
      body: ListView.builder(
          itemCount: widget.itemList?.length,
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
                  widget.itemList![index]['name'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${widget.itemList![index]['quantity'].toString()}, ${widget.itemList![index]['price'].toString()}",
                ),
                trailing: IconButton(
                    onPressed: () {
                      cartbloc.addToCart(widget.itemList![index]);
                      print(cartbloc.cartItems.value);
                    },
                    icon: Icon(Icons.shopping_cart)),
              ),
            );
          }),
    );
  }

  manyItemsDetected(List? items, SearchInfo? searchInfo) {
    List itemList = items!
        .where((item) => item['quantity']
            .toString()
            .toLowerCase()
            .contains(searchInfo!.item!.size.toString().trim()))
        .toList();
    return itemList;
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
    var items = manyItemsDetected(widget.itemList, searchInfo);
    cartbloc.addToCart(items[0]);
    return SearchAppState.WAITING;
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
