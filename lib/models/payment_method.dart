class PaymentMethodModel {
  String iconURL, name, country, currency, code;
  bool isActived;

  PaymentMethodModel({
    required this.iconURL,
    required this.code,
    required this.name,
    required this.country,
    required this.currency,
    required this.isActived,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      iconURL: json['icon_url'],
      name: json['name'],
      country: json['country'],
      code: json['code'],
      currency: json['currency'],
      isActived: json['is_activated'],
    );
  }
}
