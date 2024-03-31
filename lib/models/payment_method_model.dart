class PaymentMethodModelOutlet {
  String iconURL, name, code;

  PaymentMethodModelOutlet({
    required this.iconURL,
    required this.code,
    required this.name,
  });

  factory PaymentMethodModelOutlet.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModelOutlet(
      iconURL: json['icon_url'],
      name: json['name'],
      code: json['code'],
    );
  }
}
