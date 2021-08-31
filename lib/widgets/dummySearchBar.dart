import 'package:atc_kw/screens/searchDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DummySearchBar extends StatefulWidget
    implements SearchBarOnItemClickListener {
  // Function that is run when any suggestion from the searchDialog is clicked
  Function? initiateSearch;

  // Default display term
  String initialDisplayTerm = "Search Items";

  // Current display term
  String? displayTerm = "Search Items";

  DummySearchBar(this.initiateSearch, {this.displayTerm});

  @override
  _DummySearchBarState createState() => _DummySearchBarState();

  @override
  void onSearchItemClick(String searchTerm) {
    print('onSearchItemClick');
    initiateSearch!(query: searchTerm);
  }
}

class _DummySearchBarState extends State<DummySearchBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(15),
        child: Container(
          color: Colors.white,
          height: 50,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.search,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    (widget.displayTerm == null)
                        ? '${widget.initialDisplayTerm}'
                        : '${widget.displayTerm}',
                    style: TextStyle(color: Colors.grey),
                  ))
            ],
          ),
        ),
      ),
      onTap: () {
        SearchDialog searchDialog = SearchDialog(widget.initiateSearch, widget);
        // Sets what happens when we click on any suggestion from the searchDialog
        searchDialog.setOnItemClickListener(widget);
        Get.to(searchDialog);
      },
    );
  }
}
