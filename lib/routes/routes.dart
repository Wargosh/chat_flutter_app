import 'package:flutter/material.dart';

import 'package:chat_flutter_app/pages/pages.dart';

class Routes {
  static const String usersPage = 'users';
  static const String loginPage = 'login';
  static const String registerPage = 'register';
  static const String loadingPage = 'loading';
  static const String chatPage = 'chat';
}

final Map<String, Widget Function(BuildContext)> appRoutes = {
  Routes.usersPage: (_) => const UsersPage(),
  Routes.chatPage: (_) => const ChatPage(),
  Routes.registerPage: (_) => const RegisterPage(),
  Routes.loginPage: (_) => const LoginPage(),
  Routes.loadingPage: (_) => const LoadingPage()
};
