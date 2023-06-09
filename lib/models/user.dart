class User {
  String username;
  String email;
  String uid;
  bool online;

  User({
    required this.username,
    required this.email,
    required this.uid,
    required this.online,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        email: json["email"],
        uid: json["uid"],
        online: json["online"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "uid": uid,
        "online": online,
      };
}
