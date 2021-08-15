import 'dart:convert';

import 'package:flutter/services.dart';

import 'models/Product.dart';

/// Singleton class for data operartions
class Data{

  static Data? _instance;
  static List<Product>? allProducts;

  Data._data(){
   getAllProducts().then((productList) {
     allProducts = productList;
   });
  }

  static Data getInstance(){
    if(_instance==null){
      _instance = Data._data();
    }
    return (_instance as Data);
  }

  Future<List<Product>> getAllProducts() async {
    String response = await rootBundle.loadString('assets/list.json');
    var products = await json.decode(response);
    List<Product> productList = [];
    for (var product in products) {
      productList.add(Product.fromJson(product));
    }
    return productList;
  }


}