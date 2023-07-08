import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

@JsonSerializable()
class LoginResponse {
  bool? error;
  String? message;
  LoginResultResponse? loginResult;

  LoginResponse({
    this.error,
    this.message,
    this.loginResult,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginResultResponse {
  String? userId;
  String? name;
  String? token;

  LoginResultResponse({
    this.userId,
    this.name,
    this.token,
  });

  factory LoginResultResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResultResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultResponseToJson(this);
}
