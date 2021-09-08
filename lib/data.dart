import 'dart:convert';

import 'package:atc_kw/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'models/Product.dart';

/// Singleton class for fetching and caching data from JSON
class Data {
  // (productId -> Product)
  static Map<int, Product>? _allProductMap;
  static Data instance = new Data._();

  // Private constructor
  Data._() {
    getAllProducts().then((productMap) {
      _allProductMap = productMap;
    });
  }

  Map<int, Product>? get allProductMap => _allProductMap;

  Future<Map<int, Product>> getAllProducts() async {
    var response = await makeServerRequest();
    // var response = await http.get(Uri.parse(getUrl("", 1000)));
    print(response.body);
    var jsonData = await json.decode(response.body);
    Map<int, Product> productMap = _getProductMapFromJsonData(jsonData);
    return productMap;

    // String response = await rootBundle.loadString('assets/list.json');
    // var products = await json.decode(response);
    // Map<int, Product> productMap = new Map();
    // for (var productJson in products) {
    //   Product product = Product.fromJson(productJson);
    //   int id = product.id;
    //   productMap[id] = product;
    // }
    // return productMap;
  }

  // Map<int, Product> getSearchProducts(String? query) {
  //   Map<int, Product> searchProductMap = new Map();
  //   _allProductMap!.entries.forEach((element) {
  //     int productID = element.key;
  //     Product product = element.value;
  //     if (product.name.toLowerCase().contains(query!.toLowerCase().trim())) {
  //       searchProductMap[productID] = product;
  //     }
  //   });
  //   return searchProductMap;
  // }

  Future<Map<int, Product>> getSearchProducts(String? query) async {
    // var response = await http.get(Uri.parse(getUrl(query!, 30)));
    var response = await makeServerRequest(searchTerm: query!);
    var jsonData = await json.decode(response.body);
    Map<int, Product> productMap = _getProductMapFromJsonData(jsonData);
    return productMap;
  }

  makeServerRequest(QueryType queryType, {String? searchTerm, int? sizeInt}) {
    return http.post(
      Uri.parse(searchUrl),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: (queryType == QueryType.ALL_PRODUCTS)
          ? _getBody(queryType)
          : (queryType == QueryType.BY_NAME)
              ? _getBody(queryType, searchTerm: searchTerm)
              : _getBody(queryType, searchTerm: searchTerm, sizeInt: sizeInt),
    );
  }

  Map<int, Product> _getProductMapFromJsonData(var jsonData) {
    var hits = jsonData['hits'];
    List hitsList = hits['hits'];
    Map<int, Product> productMap = new Map();
    for (var hit in hitsList) {
      Product product = Product.fromJson(hit['_source']);
      int id = product.id;
      productMap[id] = product;
    }
    return productMap;
  }

  String getUrl(String searchTerm, int size) {
    String url = baseUrl +
        "_search?q=" +
        "*" +
        searchTerm +
        "*" +
        "&_source_includes=@_index,brand,id,imageUrl,name,price,size,sizeInt,synonyms,unit" +
        "&size=" +
        size.toString();
    print(url);
    return url;
  }

  _getBody(QueryType queryType, {String searchTerm = "", int sizeInt = 1}) {
    switch (queryType) {
      case QueryType.ALL_PRODUCTS:
        return jsonEncode(<String, Object>{
          "query": {"match_all": {}}
        });
      case QueryType.BY_NAME:
        return jsonEncode(<String, Object>{
          "query": {
            "match": {"name": "$searchTerm"}
          }
        });
      case QueryType.BY_NAME_SIZE:
        return jsonEncode(<String, Object>{
          "query": {
            "bool": {
              "must": [
                {
                  "match": {"name": "$searchTerm"}
                },
                {
                  "match": {"sizeInt": "$sizeInt"}
                }
              ]
            }
          }
        });
    }
  }
}

enum QueryType { ALL_PRODUCTS, BY_NAME, BY_NAME_SIZE }
