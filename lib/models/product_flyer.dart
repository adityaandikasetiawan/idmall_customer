class ProductFlyer {
  int id;
  String category;
  String name;
  int speed;
  int price;
  String code;
  String path;

  ProductFlyer({
    required this.id,
    required this.category,
    required this.name,
    required this.speed,
    required this.price,
    required this.code,
    required this.path,
  });

  factory ProductFlyer.fromJson(Map<String, dynamic> json) {
    return ProductFlyer(
      id: json["id"],
      category: json["category"],
      name: json["product_name"],
      speed: json["speed"],
      price: json["price"],
      code: json["product_code"],
      path: json['path'],
    );
  }

  static List<ProductFlyer> fromJsonList(List list) {
    return list.map((item) => ProductFlyer.fromJson(item)).toList();
  }
}
