import 'package:flutter/material.dart';

import 'package:chat_flutter_app/pages/pages.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users': (_) => const UsersPage(),
  'chat': (_) => const ChatPage(),
  'register': (_) => const RegisterPage(),
  'login': (_) => const LoginPage(),
  'loading': (_) => const LoadingPage()
};
