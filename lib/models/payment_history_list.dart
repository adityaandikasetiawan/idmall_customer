class PaymentHistoryList {
  String periode;
  int monthlyPrice;

  PaymentHistoryList({
    required this.periode,
    required this.monthlyPrice,
  });

  factory PaymentHistoryList.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryList(
      periode: json['Due_Date'],
      monthlyPrice: json['AR_Paid'].toInt() ?? 0,
    );
  }
}
