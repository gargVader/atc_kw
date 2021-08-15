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
    id = json['id'];
    name = json['name'];
    synonyms = json['synonyms'];
    brand = json['brand'];
    price = double.parse((json['price']).toString());
    sizeInt = json['sizeInt'];
    size = json['size'];
    unit = json['unit'];
    imageUrl = json['imageUrl'];
  }
}
