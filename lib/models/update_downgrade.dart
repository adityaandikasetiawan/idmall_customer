class UpdateDownGradeModel {
  int orderNo;
  String taskID;
  String customerSubName;
  String customerID;
  String customerName;
  String subProduct;
  String customerSubAddress;
  String city;
  String region;
  String emailCustomer;
  String activationDate;
  int monthlyPrice;

  UpdateDownGradeModel({
    required this.orderNo,
    required this.taskID,
    required this.customerSubName,
    required this.customerID,
    required this.customerName,
    required this.subProduct,
    required this.customerSubAddress,
    required this.city,
    required this.region,
    required this.emailCustomer,
    required this.activationDate,
    required this.monthlyPrice,
  });

  factory UpdateDownGradeModel.fromJson(Map<String, dynamic> json) {
    return UpdateDownGradeModel(
      orderNo: json['Order_No'],
      taskID: json['Task_ID'],
      customerSubName: json['Customer_Sub_Name'],
      customerID: json['Customer_ID'],
      customerName: json['Customer_Name'],
      subProduct: json['Sub_Product'],
      customerSubAddress: json['Customer_Sub_Address'],
      city: json['City'],
      region: json['Region'],
      emailCustomer: json['Email_Customer'],
      activationDate: json['Activation_Date'],
      monthlyPrice: json['Monthly_Price'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Order_No'] = orderNo;
    data['Task_ID'] = taskID;
    data['Customer_Sub_Name'] = customerSubName;
    data['Customer_ID'] = customerID;
    data['Customer_Name'] = customerName;
    data['Sub_Product'] = subProduct;
    data['Customer_Sub_Address'] = customerSubAddress;
    data['City'] = city;
    data['Region'] = region;
    data['Email_Customer'] = emailCustomer;
    data['Activation_Date'] = activationDate;
    data['Monthly_Price'] = monthlyPrice;
    return data;
  }
}
