class UserData {
  String? userId;
  String? userName;
  String? userToken;

  UserData({
    this.userId,
    this.userName,
    this.userToken,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
      userId: json["userId"], userName: json["name"], userToken: json["token"]);

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": userName,
        "token": userToken,
      };
}
