class PaymentTransaction {
  final String taskId;
  final String customerSubName;
  final int monthlyPrice;
  final String subProduct;
  final String services;
  final int installation;
  final int vat;
  final int total;
  final int payment;
  final int arRemain;
  final int arVal;
  final int arPaid;
  final String dueDate;
  final String invDate;
  final String ptp;
  final String bankAcc;
  final int subtotal;
  final int materai;
  final int ppn;
  final int grandTotal;

  PaymentTransaction({
    required this.taskId,
    required this.customerSubName,
    required this.monthlyPrice,
    required this.subProduct,
    required this.services,
    required this.installation,
    required this.vat,
    required this.total,
    required this.payment,
    required this.arRemain,
    required this.arVal,
    required this.arPaid,
    required this.dueDate,
    required this.invDate,
    required this.ptp,
    required this.bankAcc,
    required this.subtotal,
    required this.materai,
    required this.ppn,
    required this.grandTotal,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      taskId: json['Task_ID'] ?? '',
      customerSubName: json['Customer_Sub_Name'] ?? '',
      monthlyPrice: json['Monthly_Price'] ?? 0,
      subProduct: json['Sub_Product'] ?? '',
      services: json['Services'] ?? '',
      installation: json['Installation'] ?? 0,
      vat: json['vat'] ?? 0,
      total: json['total'] ?? 0,
      payment: json['Payment'] ?? 0,
      arRemain: json['AR_Remain'] ?? 0,
      arVal: json['AR_Val'] ?? 0,
      arPaid: json['AR_Paid'] ?? 0,
      dueDate: json['Due_Date'] ?? '',
      invDate: json['Inv_Date'] ?? '',
      ptp: json['PTP'] ?? '',
      bankAcc: json['Bank_Acc'] ?? '',
      subtotal: json['Subtotal'] ?? 0,
      materai: json['Materai'] ?? 0,
      ppn: json['PPN'] ?? 0,
      grandTotal: json['Total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Task_ID': taskId,
      'Customer_Sub_Name': customerSubName,
      'Monthly_Price': monthlyPrice,
      'Sub_Product': subProduct,
      'Services': services,
      'Installation': installation,
      'vat': vat,
      'total': total,
      'Payment': payment,
      'AR_Remain': arRemain,
      'AR_Val': arVal,
      'AR_Paid': arPaid,
      'Due_Date': dueDate,
      'Inv_Date': invDate,
      'PTP': ptp,
      'Bank_Acc': bankAcc,
      'Subtotal': subtotal,
      'Materai': materai,
      'PPN': ppn,
      'Total': grandTotal,
    };
  }
}
