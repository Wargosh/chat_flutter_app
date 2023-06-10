import 'package:chat_flutter_app/models/base_response.dart';
import 'package:chat_flutter_app/models/messages_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_flutter_app/global/environment.dart';
import 'package:chat_flutter_app/models/user.dart';
import 'package:chat_flutter_app/services/auth_service.dart';

class ChatService with ChangeNotifier {
  late User userTarget;

  // routes
  static const String _getChatMessages = '/messages';

  Future<List<Message>> getChat(String uidTarget) async {
    try {
      final result = await http.get(
        Uri.parse('${Environment.apiUrl}$_getChatMessages/$uidTarget'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? ''
        },
      );

      final response = baseResponseFromJson(result.body);
      if (result.statusCode == 200 && response.success) {
        final data = messagesResponseFromJson(response.payload);

        return data.messages;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
