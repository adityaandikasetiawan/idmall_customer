// ignore_for_file: file_names

class CustomerListAchieve {
  // String name;
  String taskID;
  // int price;
  // String activeDate;
  String status;
  // String serviceCode;
  String serviceName;

  CustomerListAchieve({
    // required this.name,
    required this.taskID,
    // required this.price,
    // required this.activeDate,
    required this.status,
    // required this.serviceCode,
    required this.serviceName,
  });

  factory CustomerListAchieve.fromJson(Map<String, dynamic> json) {
    return CustomerListAchieve(
      // name: json["name"],
      taskID: json["Task_ID"] as String,
      // price: json["price"],
      // activeDate: json["activeDate"] ?? '',
      status: json["Status"] ?? '',
      // serviceCode: json["serviceCode"] ?? '',
      serviceName: json["Sub_Product"] ?? '',
    );
  }

  static List<CustomerListAchieve> fromJsonList(List list) {
    return list.map((item) => CustomerListAchieve.fromJson(item)).toList();
  }
}
