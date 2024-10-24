class PaymentHistoryDetail {
  final String taskId;
  final String customerSubName;
  final int monthlyPrice;
  final String subProduct;
  final String services;
  final int installation;
  final String caStatus;
  final int vat;
  final int total;
  final int payment;
  final int arRemain;
  final int arVal;
  final String dueDate;
  final String invDate;
  final String arStatus;
  final String paymentDate;
  final String paymentMethod;
  final int subtotal;
  final int materai;
  final int ppn;
  final int finalTotal;

  PaymentHistoryDetail({
    required this.taskId,
    required this.customerSubName,
    required this.monthlyPrice,
    required this.subProduct,
    required this.services,
    required this.installation,
    required this.caStatus,
    required this.vat,
    required this.total,
    required this.payment,
    required this.arRemain,
    required this.arVal,
    required this.dueDate,
    required this.invDate,
    required this.arStatus,
    required this.paymentDate,
    required this.paymentMethod,
    required this.subtotal,
    required this.materai,
    required this.ppn,
    required this.finalTotal,
  });

  // Factory method untuk membuat instance dari JSON
  factory PaymentHistoryDetail.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryDetail(
      taskId: json['Task_ID'] as String,
      customerSubName: json['Customer_Sub_Name'] as String,
      monthlyPrice: json['Monthly_Price'] as int,
      subProduct: json['Sub_Product'] as String,
      services: json['Services'] as String,
      installation: json['Installation'] as int,
      caStatus: json['CA_Status'] as String,
      vat: json['vat'] as int,
      total: json['total'] as int,
      payment: json['Payment'] as int,
      arRemain: json['AR_Remain'] as int,
      arVal: json['AR_Val'] as int,
      dueDate: json['Due_Date'] as String,
      invDate: json['Inv_Date'] as String,
      arStatus: json['AR_Status'] as String,
      paymentDate: json['Payment_Date'] as String,
      paymentMethod: json['Payment_Method'] as String,
      subtotal: json['Subtotal'] as int,
      materai: json['Materai'] as int,
      ppn: json['PPN'] as int,
      finalTotal: json['Total'] as int,
    );
  }

  // Method untuk mengubah instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'Task_ID': taskId,
      'Customer_Sub_Name': customerSubName,
      'Monthly_Price': monthlyPrice,
      'Sub_Product': subProduct,
      'Services': services,
      'Installation': installation,
      'CA_Status': caStatus,
      'vat': vat,
      'total': total,
      'Payment': payment,
      'AR_Remain': arRemain,
      'AR_Val': arVal,
      'Due_Date': dueDate,
      'Inv_Date': invDate,
      'AR_Status': arStatus,
      'Payment_Date': paymentDate,
      'Payment_Method': paymentMethod,
      'Subtotal': subtotal,
      'Materai': materai,
      'PPN': ppn,
      'Total': finalTotal,
    };
  }
}
