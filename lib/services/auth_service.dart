import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_flutter_app/global/environment.dart';
import 'package:chat_flutter_app/utils/local_storage.dart';

import 'package:chat_flutter_app/models/user.dart';
import 'package:chat_flutter_app/models/base_response.dart';
import 'package:chat_flutter_app/models/login_response.dart';
import 'package:chat_flutter_app/models/register_response.dart';

class AuthService with ChangeNotifier {
  User? user;
  bool _isLoading = false;
  final _localStorage = LocalStorage();

  // routes
  static const String _login = '/login';
  static const String _register = '/login/new';
  static const String _renewToken = '/login/renew';

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // static getters of token
  static Future<String?> getToken() async {
    final storage = LocalStorage();
    final token = await storage.getSession('token');
    return token;
  }

  static Future<void> deleteToken() async {
    final storage = LocalStorage();
    await storage.removeSession('token');
  }

  Future<String> login(String email, String password) async {
    isLoading = true;

    final data = {'email': email, 'password': password};

    final result = await http.post(
      Uri.parse('${Environment.apiUrl}$_login'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    final response = baseResponseFromJson(result.body);
    if (result.statusCode == 200 && response.success) {
      final data = loginResponseFromJson(response.payload);
      user = data.user;

      await _localStorage.saveSession('token', data.token);
    }

    isLoading = false;
    return response.message;
  }

  Future<String> register(
      String username, String email, String password) async {
    isLoading = true;

    final data = {'username': username, 'email': email, 'password': password};

    final result = await http.post(
      Uri.parse('${Environment.apiUrl}$_register'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    final response = baseResponseFromJson(result.body);
    if (result.statusCode == 200 && response.success) {
      final data = registerResponseFromJson(response.payload);
      user = data.user;

      await _localStorage.saveSession('token', data.token);
    }

    isLoading = false;
    return response.message;
  }

  Future<bool> isLoggedIn() async {
    final token = await _localStorage.getSession('token');

    if (token == null) {
      return false;
    }

    final result = await http.get(
      Uri.parse('${Environment.apiUrl}$_renewToken'),
      headers: {'Content-Type': 'application/json', 'x-token': token},
    );

    final response = baseResponseFromJson(result.body);
    if (result.statusCode == 200 && response.success) {
      final data = loginResponseFromJson(response.payload);
      user = data.user;

      await _localStorage.saveSession('token', data.token);
      return true;
    }

    await logout();
    return false;
  }

  Future<void> logout() async {
    await _localStorage.removeSession('token');
  }
}
