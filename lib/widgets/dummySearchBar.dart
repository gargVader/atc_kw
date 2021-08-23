import 'package:atc_kw/screens/searchDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DummySearchBar extends StatelessWidget implements SearchBarOnItemClickListener{
  Function? initiateSearch;

  DummySearchBar(this.initiateSearch);

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
                    'Search items',
                    style: TextStyle(color: Colors.grey),
                  ))
            ],
          ),
        ),
      ),
      onTap: () {
        SearchDialog searchDialog = SearchDialog(initiateSearch);
        searchDialog.setOnItemClickListener(this);
        Get.to(searchDialog);
      },
    );
  }

  @override
  void onSearchItemClick(String searchTerm) {
    // TODO: implement onSearchItemClick
    print('onSearchItemClick');
    initiateSearch!(query: searchTerm);
  }
}
