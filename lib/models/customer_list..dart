class CustomerListAchieve {
  String name;
  String taskID;
  int price;
  String activeDate;
  String status;
  String serviceCode;
  String serviceName;

  CustomerListAchieve({required this.name, required this.taskID,required this.price,required this.activeDate, required this.status, required this.serviceCode, required this.serviceName});

  factory CustomerListAchieve.fromJson(Map<String, dynamic> json) {
    // if (json['id'] == null) return null;
    return CustomerListAchieve(
      name: json["name"],
      taskID: json["taskID"] as String,
      price: json["price"],
      activeDate: json["activeDate"] ?? '',
      status: json["status"] ?? '',
      serviceCode: json["serviceCode"] ?? '',
      serviceName: json["serviceName"] ?? '',
    );
  }

  static List<CustomerListAchieve> fromJsonList(List list) {
    return list.map((item) => CustomerListAchieve.fromJson(item)).toList();
  }
}