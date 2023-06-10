import 'package:chat_flutter_app/models/users_response.dart';
import 'package:http/http.dart' as http;

import 'package:chat_flutter_app/global/environment.dart';
import 'package:chat_flutter_app/services/auth_service.dart';
import 'package:chat_flutter_app/models/user.dart';
import 'package:chat_flutter_app/models/base_response.dart';

class UsersService {
  // routes
  static const String _getUsers = '/users';

  Future<List<User>> getUsers() async {
    try {
      final result = await http.get(
        Uri.parse('${Environment.apiUrl}$_getUsers'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? ''
        },
      );

      final response = baseResponseFromJson(result.body);
      if (result.statusCode == 200 && response.success) {
        final data = usersResponseFromJson(response.payload);

        return data.users;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
