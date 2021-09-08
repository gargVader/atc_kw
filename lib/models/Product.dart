class Product {
  int id = 0;
  String name = "";
  String synonyms = "";
  String brand = "";
  double price = 0;
  int sizeInt = 0;
  String size = "";
  String unit = "";
  String imageUrl = "";

  Product(this.id, this.name, this.synonyms, this.brand, this.price,
      this.sizeInt, this.size, this.unit, this.imageUrl);

  Product.fromJson(Map<String, dynamic> json) {
    try {
      if (!(json['id'] is int)) {
        print('id=' + json['id'] + " not int");
        id = int.parse(json['id']);
        print('id=' + id.toString() + " after casting");
      } else {
        id = json['id'];
      }

      name = json['name'];
      synonyms = json['synonyms'];
      brand = json['brand'];
      price = double.parse((json['price']).toString());
      sizeInt = json['sizeInt'];
      size = json['size'];
      unit = json['unit'];
      imageUrl = json['imageUrl'];
    } catch (e) {
      print("Exception Girish=" + e.toString());

      // try {
      //   id = json['id'];
      // } catch (e) {
      //   print('json[\'id\']='+json['id']+" "+json['id'].runtimeType.toString());
      // }
      //
      // try {
      //   name = json['name'];
      // } catch (e) {
      //   print('json[\'name\']='+json['name']+" "+json['name'].runtimeType.toString());
      // }
      //
      // try {
      //   synonyms = json['synonyms'];
      // } catch (e) {
      //   print('json[\'synonyms\']='+json['synonyms']+" "+json['synonyms'].runtimeType.toString());
      // }
      //
      // try {
      //   brand = json['brand'];
      // } catch (e) {
      //   print('json[\'brand\']='+json['brand']+" "+json['brand'].runtimeType.toString());
      // }
      //
      // try {
      //   price = json['price'];
      // } catch (e) {
      //   print('json[\'price\']='+json['price']+" "+json['price'].runtimeType.toString());
      // }
      //
      // try {
      //   sizeInt = json['sizeInt'];
      // } catch (e) {
      //   print('json[\'sizeInt\']='+json['sizeInt']+" "+json['sizeInt'].runtimeType.toString());
      // }

      print(json);
    }
  }
}
