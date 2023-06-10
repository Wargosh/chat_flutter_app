import 'dart:convert';

MessagesResponse messagesResponseFromJson(Map<String, dynamic> json) =>
    MessagesResponse.fromJson(json);

String messagesResponseToJson(MessagesResponse data) =>
    json.encode(data.toJson());

class MessagesResponse {
  int start;
  int limit;
  int count;
  List<Message> messages;

  MessagesResponse({
    required this.start,
    required this.limit,
    required this.count,
    required this.messages,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      MessagesResponse(
        start: json["start"],
        limit: json["limit"],
        count: json["count"],
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "limit": limit,
        "count": count,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  String from;
  String to;
  String message;
  DateTime createdAt;
  DateTime updatedAt;

  Message({
    required this.from,
    required this.to,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        from: json["from"],
        to: json["to"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "message": message,
        "created_at": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
