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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Order_No'] = this.orderNo;
    data['Task_ID'] = this.taskID;
    data['Customer_Sub_Name'] = this.customerSubName;
    data['Customer_ID'] = this.customerID;
    data['Customer_Name'] = this.customerName;
    data['Sub_Product'] = this.subProduct;
    data['Customer_Sub_Address'] = this.customerSubAddress;
    data['City'] = this.city;
    data['Region'] = this.region;
    data['Email_Customer'] = this.emailCustomer;
    data['Activation_Date'] = this.activationDate;
    data['Monthly_Price'] = this.monthlyPrice;
    return data;
  }
}
