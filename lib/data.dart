import 'dart:convert';

import 'package:flutter/services.dart';

import 'models/Product.dart';

/// Singleton class for data operartions
class Data{

  static Map<int, Product>? _allProductMap;
  static Data instance = new Data._();

  // Private constructor
  Data._(){
   getAllProducts().then((productMap) {
     _allProductMap = productMap;
   });
  }

  Map<int, Product>? get allProductMap => _allProductMap;

  Future<Map<int, Product>> getAllProducts() async {
    String response = await rootBundle.loadString('assets/list.json');
    var products = await json.decode(response);
    Map<int, Product> productMap = new Map();
    for (var productJson in products) {
      Product product = Product.fromJson(productJson);
      int id = product.id;
      productMap[id] = product;
    }
    return productMap;
  }


}