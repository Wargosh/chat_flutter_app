import 'dart:convert';

import 'package:chat_flutter_app/models/user.dart';

UsersResponse usersResponseFromJson(Map<String, dynamic> json) =>
    UsersResponse.fromJson(json);

String usersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {
  int start;
  int limit;
  int count;
  List<User> users;

  UsersResponse({
    required this.start,
    required this.limit,
    required this.count,
    required this.users,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        start: json["start"],
        limit: json["limit"],
        count: json["count"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "limit": limit,
        "count": count,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}
