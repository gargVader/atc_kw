import 'dart:convert';

import 'package:atc_kw/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'models/Product.dart';

class Pair<E, F> {
  final E product;
  final F score;

  Pair(this.product, this.score);

  @override
  String toString() => '($product, $score)';

  @override
  bool operator ==(other) {
    if (other is! Pair) {
      return false;
    }
    return other.product == product && other.score == score;
  }
}

/// Singleton class for fetching and caching data from JSON
class Data {
  // (productId -> Product)
  static Map<int, Pair<Product, double>>? _allProductMap;
  static Data instance = new Data._();

  // Private constructor
  Data._() {
    getAllProducts().then((productMap) {
      _allProductMap = productMap;
    });
  }

  Map<int, Pair<Product, double>>? get allProductMap => _allProductMap;

  // Returns all products. Displayed in home
  Future<Map<int, Pair<Product, double>>> getAllProducts() async {
    var response = await makeServerRequest();
    var jsonData = await json.decode(response.body);
    Map<int, Pair<Product, double>> productMap =
        _getProductMapFromJsonData(jsonData);
    return productMap;
  }

  // Returns relevant products based on searchTerm
  Future<Map<int, Pair<Product, double>>> getSearchProducts(
      String? searchTerm) async {
    var response = await makeServerRequest(searchTerm: searchTerm!);
    var jsonData = await json.decode(response.body);
    Map<int, Pair<Product, double>> productMap =
        _getProductMapFromJsonData(jsonData);
    return productMap;
  }

  // Makes server request
  makeServerRequest({String searchTerm = ""}) {
    return http.post(
      Uri.parse(searchUrl),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: _getBody(searchTerm),
    );
  }

  // Parses json to return map of products
  Map<int, Pair<Product, double>> _getProductMapFromJsonData(var jsonData) {
    List hitsList = jsonData['hits']['hits'];
    Map<int, Pair<Product, double>> productMap = new Map();
    for (var hit in hitsList) {
      double score = hit['_score'];
      Product product = Product.fromJson(hit['_source']);
      int id = product.id;
      productMap[id] = Pair(product, score);
    }
    return productMap;
  }

  // Returns body of server request
  _getBody(String searchTerm) {
    if (searchTerm == "") {
      return jsonEncode(<String, Object>{
        "size": 1100,
        "query": {"match_all": {}}
      });
    }
    return jsonEncode(<String, Object>{
      "query": {
        "bool": {
          "must": [
            {
              "bool": {
                "must": [
                  {
                    "bool": {
                      "should": [
                        {
                          "multi_match": {
                            "query": "$searchTerm",
                            "fields": [
                              "brand^3",
                              "imageUrl^3",
                              "name^3",
                              "size^3",
                              "synonyms^3",
                              "unit^3",
                              "brand.raw^3",
                              "imageUrl.raw^3",
                              "name.raw^3",
                              "size.raw^3",
                              "synonyms.raw^3",
                              "unit.raw^3",
                              "brand.search^1",
                              "imageUrl.search^1",
                              "name.search^1",
                              "size.search^1",
                              "synonyms.search^1",
                              "unit.search^1",
                              "brand.autosuggest^1",
                              "imageUrl.autosuggest^1",
                              "name.autosuggest^1",
                              "size.autosuggest^1",
                              "synonyms.autosuggest^1",
                              "unit.autosuggest^1",
                              "brand.english^1",
                              "imageUrl.english^1",
                              "name.english^1",
                              "size.english^1",
                              "synonyms.english^1",
                              "unit.english^1"
                            ],
                            "type": "cross_fields",
                            "operator": "and"
                          }
                        },
                        {
                          "multi_match": {
                            "query": "$searchTerm",
                            "fields": [
                              "brand^3",
                              "imageUrl^3",
                              "name^3",
                              "size^3",
                              "synonyms^3",
                              "unit^3",
                              "brand.raw^3",
                              "imageUrl.raw^3",
                              "name.raw^3",
                              "size.raw^3",
                              "synonyms.raw^3",
                              "unit.raw^3",
                              "brand.search^1",
                              "imageUrl.search^1",
                              "name.search^1",
                              "size.search^1",
                              "synonyms.search^1",
                              "unit.search^1",
                              "brand.autosuggest^1",
                              "imageUrl.autosuggest^1",
                              "name.autosuggest^1",
                              "size.autosuggest^1",
                              "synonyms.autosuggest^1",
                              "unit.autosuggest^1",
                              "brand.english^1",
                              "imageUrl.english^1",
                              "name.english^1",
                              "size.english^1",
                              "synonyms.english^1",
                              "unit.english^1"
                            ],
                            "type": "phrase",
                            "operator": "and"
                          }
                        },
                        {
                          "multi_match": {
                            "query": "$searchTerm",
                            "fields": [
                              "brand^3",
                              "imageUrl^3",
                              "name^3",
                              "size^3",
                              "synonyms^3",
                              "unit^3",
                              "brand.raw^3",
                              "imageUrl.raw^3",
                              "name.raw^3",
                              "size.raw^3",
                              "synonyms.raw^3",
                              "unit.raw^3",
                              "brand.english^1",
                              "imageUrl.english^1",
                              "name.english^1",
                              "size.english^1",
                              "synonyms.english^1",
                              "unit.english^1"
                            ],
                            "type": "phrase_prefix",
                            "operator": "and"
                          }
                        }
                      ],
                      "minimum_should_match": "1"
                    }
                  }
                ]
              }
            }
          ]
        }
      },
      "size": 100,
      "_source": {
        "includes": ["*"],
        "excludes": []
      },
      "from": 0,
      "sort": [
        {
          "_score": {"order": "desc"},
          "_id": {"order": "desc"}
        }
      ],
      "track_total_hits": true
    });
  }
}

//   String getUrl(String searchTerm, int size) {
//     String url = baseUrl +
//         "_search?q=" +
//         "*" +
//         searchTerm +
//         "*" +
//         "&_source_includes=@_index,brand,id,imageUrl,name,price,size,sizeInt,synonyms,unit" +
//         "&size=" +
//         size.toString();
//     print(url);
//     return url;
//   }
//
//
//   _getBody(QueryType queryType, {String searchTerm = "", int sizeInt = 1}) {
//     switch (queryType) {
//       case QueryType.ALL_PRODUCTS:
//         return jsonEncode(<String, Object>{
//           "query": {"match_all": {}}
//         });
//       case QueryType.BY_NAME:
//         return jsonEncode(<String, Object>{
//           "query": {
//             "match": {"name": "$searchTerm"}
//           }
//         });
//       case QueryType.BY_NAME_SIZE:
//         return jsonEncode(<String, Object>{
//           "query": {
//             "bool": {
//               "must": [
//                 {
//                   "match": {"name": "$searchTerm"}
//                 },
//                 {
//                   "match": {"sizeInt": "$sizeInt"}
//                 }
//               ]
//             }
//           }
//         });
//     }
//   }
// }
//
// enum QueryType { ALL_PRODUCTS, BY_NAME, BY_NAME_SIZE }

// makeServerRequest(QueryType queryType, {String? searchTerm, int? sizeInt}) {
//   return http.post(
//     Uri.parse(searchUrl),
//     headers: <String, String>{
//       'Content-type': 'application/json; charset=UTF-8',
//     },
//     body: (queryType == QueryType.ALL_PRODUCTS)
//         ? _getBody(queryType)
//         : (queryType == QueryType.BY_NAME)
//         ? _getBody(queryType, searchTerm: searchTerm)
//         : _getBody(queryType, searchTerm: searchTerm, sizeInt: sizeInt),
//   );
// }

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
