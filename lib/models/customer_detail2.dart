class CustomerDetail2 {
  final int id;
  final String customerId;
  final String customerName;
  final String customerSubName;
  final String customerSubAddress;
  final int monthlyPrice;
  final String activationDate;
  final String eKtp;
  final String handphone;
  final String emailCustomer;
  final String zipCode;
  final String latitude;
  final String longitude;
  final String services;
  final String district;
  final String province;
  final String city;
  final String status;
  final String subProduct;
  final String productDisplayName;
  final String zipCodeDisplayName;
  final List<Note> notes;
  final List<File> files;

  CustomerDetail2({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerSubName,
    required this.customerSubAddress,
    required this.monthlyPrice,
    required this.activationDate,
    required this.eKtp,
    required this.handphone,
    required this.emailCustomer,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
    required this.services,
    required this.district,
    required this.province,
    required this.city,
    required this.status,
    required this.subProduct,
    required this.productDisplayName,
    required this.zipCodeDisplayName,
    required this.notes,
    required this.files,
  });

  factory CustomerDetail2.fromJson(Map<String, dynamic> json) {
    return CustomerDetail2(
      id: json['ID'],
      customerId: json['Customer_ID'],
      customerName: json['Customer_Name'],
      customerSubName: json['Customer_Sub_Name'],
      customerSubAddress: json['Customer_Sub_Address'],
      monthlyPrice: json['Monthly_Price'],
      activationDate: json['Activation_Date'],
      eKtp: json['E_KTP'],
      handphone: json['Handphone'],
      emailCustomer: json['Email_Customer'],
      zipCode: json['ZipCode'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
      services: json['Services'],
      district: json['District'],
      province: json['Province'],
      city: json['City'],
      status: json['Status'],
      subProduct: json['Sub_Product'],
      productDisplayName: json['Product_Display_Name'],
      zipCodeDisplayName: json['ZipCode_Display_Name'],
      notes:
          (json['Notes'] as List).map((note) => Note.fromJson(note)).toList(),
      files:
          (json['Files'] as List).map((file) => File.fromJson(file)).toList(),
    );
  }
}

class Note {
  final int id;
  final int customerId;
  final String status;
  final String statusFrom;
  final String note;
  final String? createdDate;
  final String createdBy;

  Note({
    required this.id,
    required this.customerId,
    required this.status,
    required this.statusFrom,
    required this.note,
    this.createdDate,
    required this.createdBy,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['ID'],
      customerId: json['Customer_ID'],
      status: json['Status'],
      statusFrom: json['Status_From'],
      note: json['Note'],
      createdDate: json['Created_Date'],
      createdBy: json['Created_By'],
    );
  }
}

class File {
  final int id;
  final String kategoriFile;
  final String jenisFile;
  final String filePath;
  final String createdDate;
  final String createdBy;
  final String uploadMenu;

  File({
    required this.id,
    required this.kategoriFile,
    required this.jenisFile,
    required this.filePath,
    required this.createdDate,
    required this.createdBy,
    required this.uploadMenu,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['ID'],
      kategoriFile: json['Kategori_File'],
      jenisFile: json['Jenis_File'],
      filePath: json['FilePath'],
      createdDate: json['Created_Date'],
      createdBy: json['Created_By'],
      uploadMenu: json['Upload_Menu'],
    );
  }
}
