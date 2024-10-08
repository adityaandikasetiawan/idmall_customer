// ignore_for_file: non_constant_identifier_names

class CustomerListByEmail {
  final String name;
  final String customerId;
  final String product;
  final String status;

  CustomerListByEmail({
    required this.name,
    required this.customerId,
    required this.product,
    required this.status,
  });

  factory CustomerListByEmail.fromJson(Map<String, dynamic> json) {
    return CustomerListByEmail(
      name: json['Customer_Sub_Name'] ?? "",
      customerId: json['Task_ID'] ?? "0",
      product: json['Sub_Product'] ?? "",
      status: json['Status'] ?? "",
    );
  }
}
