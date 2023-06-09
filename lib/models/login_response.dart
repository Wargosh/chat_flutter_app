import 'dart:convert';

import 'package:chat_flutter_app/models/user.dart';

LoginResponse loginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse.fromJson(json);

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  User user;
  String token;

  LoginResponse({
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}
