import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'base_response.g.dart';

BaseResponse baseResponseFromJson(String str) =>
    BaseResponse.fromJson(json.decode(str));

@JsonSerializable()
class BaseResponse {
  bool? error;
  String? message;

  BaseResponse({
    this.error,
    this.message,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
