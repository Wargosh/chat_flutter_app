import 'dart:convert';

import 'package:chat_flutter_app/models/user.dart';

RegisterResponse registerResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse.fromJson(json);

String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  User user;
  String token;

  RegisterResponse({
    required this.user,
    required this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}
