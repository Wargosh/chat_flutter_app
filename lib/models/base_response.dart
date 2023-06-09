import 'dart:convert';

BaseResponse baseResponseFromJson(String str) =>
    BaseResponse.fromJson(json.decode(str));

String baseResponseToJson(BaseResponse data) => json.encode(data.toJson());

class BaseResponse {
  bool success;
  String message;
  dynamic payload;

  BaseResponse({
    required this.success,
    required this.message,
    this.payload,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        payload: json["payload"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "payload": payload,
      };

  Map<String, dynamic> payloadToJson() => {
        "payload": payload,
      };
}
