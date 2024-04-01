import 'package:json_annotation/json_annotation.dart';

part 'signup.g.dart';

@JsonSerializable()
class Signup {
  String? status;
  String? message;
  Data? data;

  Signup({
    this.status,
    this.data,
  });

  @override
  String toString(){
    return 'Signup{status: $status, data: $data}';
  }

  factory Signup.fromJson(Map<String,dynamic> json) => _$SignupFromJson(json);

  Map<String, dynamic> toJson() => _$SignupToJson(this);
}


@JsonSerializable()
class Data {
  String? userId;
  String? email;
  String? firstName;
  String? lastName;
  String? token;

  Data({
    this.userId,
    this.email,
    this.firstName,
    this.lastName,
    this.token
  });

  @override
  String toString(){
    return 'Data{userId: $userId, email: $email, firstName: $firstName, lastName: $lastName}';
  }

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}