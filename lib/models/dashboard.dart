class DashboardModel {
  String taskId;
  String customerName;
  String productCode;
  String productName;
  String status;
  String billStatus;
  String dueDate;
  String invDate;
  double totalPayment;
  double arRemain;
  double arPaid;
  String period;
  int points;
  double gbIn;

  DashboardModel({
    required this.taskId,
    required this.customerName,
    required this.productCode,
    required this.productName,
    required this.status,
    required this.billStatus,
    required this.dueDate,
    required this.invDate,
    required this.totalPayment,
    required this.arRemain,
    required this.arPaid,
    required this.period,
    required this.points,
    required this.gbIn,
  });

  // Factory method to create a DashboardModel from JSON
  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      taskId: json['Task_ID'],
      customerName: json['Customer_Name'],
      productCode: json['Product_Code'],
      productName: json['Product_Name'],
      status: json['Status'],
      billStatus: json['Bill_Status'],
      dueDate: json['Due_Date'],
      invDate: json['Inv_Date'],
      totalPayment: json['Total_Payment'].toDouble(),
      arRemain: json['AR_Remain'].toDouble(),
      arPaid: json['AR_Paid'].toDouble(),
      period: json['Period'],
      points: json['Points'],
      gbIn: json['GB_in'].toDouble(),
    );
  }

  // Method to convert TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'Task_ID': taskId,
      'Customer_Name': customerName,
      'Product_Code': productCode,
      'Product_Name': productName,
      'Status': status,
      'Bill_Status': billStatus,
      'Due_Date': dueDate,
      'Inv_Date': invDate,
      'Total_Payment': totalPayment,
      'AR_Remain': arRemain,
      'AR_Paid': arPaid,
      'Period': period,
      'Points': points,
      'GB_in': gbIn,
    };
  }
}
