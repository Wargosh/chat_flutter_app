import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_flutter_app/routes/routes.dart';
import 'package:chat_flutter_app/models/user.dart';
import 'package:chat_flutter_app/services/auth_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    User(
        uid: '1',
        username: 'Wargosh',
        email: 'wargosh@gmail.com',
        online: false),
    User(uid: '2', username: 'Gedo', email: 'gedo@gmail.com', online: false),
    User(uid: '3', username: 'Sam', email: 'sam@gmail.com', online: true),
    User(uid: '4', username: 'Axel', email: 'axel@gmail.com', online: false),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user!;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            user.username,
            style: const TextStyle(color: Colors.black54),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              // TODO: disconnect socket server

              if (!context.mounted) return;

              AuthService.deleteToken();
              Navigator.pushReplacementNamed(context, Routes.loginPage);
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.offline_bolt_outlined,
                color: Colors.red,
              ),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _loadUsers,
          header: const WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.green,
            ),
            waterDropColor: Colors.blue,
          ),
          enablePullDown: true,
          child: _listViewUsers(),
        ));
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile(users[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: users.length,
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.black45,
        child: Text(
          user.username.substring(0, 2),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(user.username),
      subtitle: Text(user.email),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[500] : Colors.black12,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  void _loadUsers() async {
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
  }
}
