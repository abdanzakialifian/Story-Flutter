import 'dart:convert';

BaseResponse baseResponseFromJson(String str) =>
    BaseResponse.fromJson(json.decode(str));

class BaseResponse {
  bool? error;
  String? message;

  BaseResponse({
    this.error,
    this.message,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
