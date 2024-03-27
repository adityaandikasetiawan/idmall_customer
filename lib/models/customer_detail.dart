class CustomerDetailAchieve {
  String name;
  String address;
  String taskID;
  int price;
  String activeDate;
  String? ktp;
  String handphone;
  String email;
  String zipCode;
  String longitude;
  String latitude;
  String service;
  String district;
  String province;
  String city;
  String productName;
  String status;

  CustomerDetailAchieve({required this.name, required this.address, required this.taskID,required this.price,required this.activeDate, this.ktp, required this.handphone, required this.email, required this.zipCode, required this.longitude, required this.latitude, required this.service, required this.district, required this.city, required this. province, required this.productName, required this.status});

  factory CustomerDetailAchieve.fromJson(Map<String, dynamic> json) {
    // if (json['id'] == null) return null;
    print(json);
    return CustomerDetailAchieve(
      name: json["Customer_Sub_Name"],
      address: json["Customer_Sub_Address"],
      taskID: json["Task_ID"] as String,
      price: json["Monthly_Price"],
      activeDate: json["Activation_Date"] ?? '',
      ktp: json['E_KTP'],
      handphone: json['Handphone'],
      email: json['Email_Customer'],
      zipCode: json['ZipCode'],
      district: json['District'],
      province: json['Province'],
      city: json['City'],
      longitude: json['Longitude'],
      latitude: json['Latitude'],
      service: json['Services'],
      productName: json['Sub_Product'],
      status: json['Status'],
    );
  }

  static List<CustomerDetailAchieve> fromJsonList(List list) {
    return list.map((item) => CustomerDetailAchieve.fromJson(item)).toList();
  }
}