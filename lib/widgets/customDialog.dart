import 'package:flutter/material.dart';
import 'package:slang_retail_assistant/slang_retail_assistant.dart';

Future<void> addToCartDialog(
    BuildContext context, SearchUserJourney? searchUserJourney) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
          elevation: 24.0,
          title: Text('Item Added to Cart'),
          content: SingleChildScrollView(
              child: ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              searchUserJourney?.setSuccess();
              searchUserJourney?.notifyAppState(SearchAppState.ADD_TO_CART);
              Navigator.of(context).pop();
            },
          )));
    },
  );
}
