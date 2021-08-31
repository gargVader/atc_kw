import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/Product.dart';

/// Singleton class for fetching and caching data from JSON
class Data {
  final String baseUrl =
      "https://6z27aL2HY:aaed9e03-dc92-44c5-8afc-47fd5f42276f@flutterslang-rzvfyuh-es.searchbase.io/list/";

  // "https://6z27aL2HY:aaed9e03-dc92-44c5-8afc-47fd5f42276f@flutterslang-rzvfyuh-es.searchbase.io/list/_search?q=**&_source_includes=@_index,brand,id,imageUrl,name,price,size,sizeInt,synonyms,unit&size=30";

  // (productId -> Product)
  static Map<int, Product>? _allProductMap;
  static Data instance = new Data._();

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

  // Private constructor
  Data._() {
    getAllProducts().then((productMap) {
      _allProductMap = productMap;
    });
  }


  Map<int, Product>? get allProductMap => _allProductMap;

  Future<Map<int, Product>> getAllProducts() async {
    var response = await http.get(Uri.parse(getUrl("", 1000)));
    var jsonData = await json.decode(response.body);
    var hits = jsonData['hits'];
    List hitsList = hits['hits'];
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

  Future<Map<int, Product>> getSearchProducts(String? query) async{
    var response = await http.get(Uri.parse(getUrl(query!, 30)));
    var jsonData = await json.decode(response.body);
    var hits = jsonData['hits'];
    List hitsList = hits['hits'];
    Map<int, Product> productMap = _getProductMapFromJsonData(jsonData);
    return productMap;
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
}
