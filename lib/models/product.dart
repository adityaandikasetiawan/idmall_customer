// ignore_for_file: non_constant_identifier_names

class Product {
  int id;
  String category;
  String group;
  String code;
  String name;
  String region;
  int price;

  Product(
      {required this.id,
      required this.category,
      required this.group,
      required this.code,
      required this.name,
      required this.region,
      required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    // if (json['id'] == null) return null;
    return Product(
      id: json["ID"],
      group: json["Product_Group"],
      category: json["Product_Category"],
      code: json["Product_Code"],
      name: json["Product_Name"],
      region: json["Region"],
      price: json["Price"],
    );
  }

  static List<Product> fromJsonList(List list) {
    return list.map((item) => Product.fromJson(item)).toList();
  }
}
