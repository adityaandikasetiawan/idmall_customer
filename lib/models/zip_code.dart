class ZipCode {
  int id;
  String zipCode;
  String city;
  String district;
  String province;
  String regional;

  ZipCode({required this.id,required this.zipCode, required this.city,required this.district,required this.province, required this.regional});

  factory ZipCode.fromJson(Map<String, dynamic> json) {
    // if (json['id'] == null) return null;
    return ZipCode(
      id: json["ID"],
      zipCode: json["ZipCode"],
      city: json["City"],
      district: json["District"],
      province: json["Province"],
      regional: json["Regional"]
    );
  }

  static List<ZipCode> fromJsonList(List list) {
    return list.map((item) => ZipCode.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String zipCodeAsString() {
    return '#${this.id} ${this.zipCode}';
  }

  ///this method will prevent the override of toString
  // bool userFilterByCreationDate(String filter) {
  //   return this.createdAt.toString().contains(filter);
  // }

  ///custom comparing function to check if two users are equal
  bool isEqual(ZipCode model) {
    // if (model.id == null) return null;
    return this.id == model.id;
  }
}