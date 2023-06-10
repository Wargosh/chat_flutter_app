import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_flutter_app/routes/routes.dart';
import 'package:chat_flutter_app/models/user.dart';

import 'package:chat_flutter_app/services/auth_service.dart';
import 'package:chat_flutter_app/services/users_service.dart';
import 'package:chat_flutter_app/services/socket_service.dart';
import 'package:chat_flutter_app/services/chat_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final usersService = UsersService();

  List<User> users = [];

  @override
  void initState() {
    _loadUsers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user!;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            user.username,
            style: const TextStyle(color: Colors.black54),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.offline_bolt_outlined,
            color: socketService.serverStatus == ServerStatus.Online
                ? Colors.green
                : Colors.red,
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  socketService.disconnect();

                  AuthService.deleteToken();
                  Navigator.pushReplacementNamed(context, Routes.loginPage);
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.black87,
                ),
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
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTarget = user;

        Navigator.pushNamed(context, Routes.chatPage);
      },
      leading: CircleAvatar(
        backgroundColor: Colors.black45,
        child: Text(
          user.username.substring(0, 2).toUpperCase(),
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
    users = await usersService.getUsers();
    setState(() {});

    _refreshController.refreshCompleted();
  }
}
