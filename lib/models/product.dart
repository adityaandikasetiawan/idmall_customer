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
        category: json["Product_Category"],
        group: json["Product_Group"],
        code: json["Product_Code"],
        name: json["Product_Name"],
        price: json["Price"],
        region: json["Region"]);
  }

  static List<Product> fromJsonList(List list) {
    return list.map((item) => Product.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String ProductAsString() {
    return '#$id $code';
  }

  ///this method will prevent the override of toString
  // bool userFilterByCreationDate(String filter) {
  //   return this.createdAt.toString().contains(filter);
  // }

  ///custom comparing function to check if two users are equal
  bool isEqual(Product model) {
    // if (model.id == null) return null;
    return id == model.id;
  }
}
