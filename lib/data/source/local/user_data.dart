import 'package:json_annotation/json_annotation.dart';
part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  String? userId;
  @JsonKey(name: "name")
  String? userName;
  @JsonKey(name: "token")
  String? userToken;

  UserData({
    this.userId,
    this.userName,
    this.userToken,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
