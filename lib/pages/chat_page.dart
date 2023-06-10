import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_flutter_app/constants/constants.dart';
import 'package:chat_flutter_app/models/messages_response.dart';
import 'package:chat_flutter_app/services/auth_service.dart';
import 'package:chat_flutter_app/services/chat_service.dart';
import 'package:chat_flutter_app/services/socket_service.dart';
import 'package:chat_flutter_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> _messages = [];

  bool _isTyping = false;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on(Constants.MSG_PRIVATE, _listenMessageFromServer);

    _loadHistory(chatService.userTarget.uid);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: off del socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userTarget = chatService.userTarget;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber[300],
              maxRadius: 14,
              child: Text(
                userTarget.username.substring(0, 2).toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              userTarget.username,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
              ),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  setState(() {
                    if (value.trim().isNotEmpty) {
                      _isTyping = true;
                    } else {
                      _isTyping = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                    hintText: 'Escribe algo...'),
                focusNode: _focusNode,
              ),
            ),

            // Send button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: MaterialButton(
                onPressed: _isTyping
                    ? () => _handleSubmit(_textController.text)
                    : null,
                child: const Text(
                  'Enviar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String message) {
    _textController.clear();
    _focusNode.requestFocus();

    setState(() {
      _isTyping = false;
    });

    message = message.trim();
    if (message.isEmpty) return;

    _addMessageToChatBody(authService.user!.uid, message);

    socketService.socket.emit(Constants.MSG_PRIVATE, {
      'from': authService.user!.uid,
      'to': chatService.userTarget.uid,
      'message': message,
    });
  }

  void _addMessageToChatBody(String uid, String message,
      {bool isPrecharged = false}) {
    final newMessage = ChatMessage(
      uid: uid,
      message: message,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: !isPrecharged ? 300 : 0),
      ),
    );
    if (isPrecharged) {
      _messages.add(newMessage);
    } else {
      _messages.insert(0, newMessage);
    }
    newMessage.animationController.forward();
  }

  _listenMessageFromServer(dynamic data) {
    print('msg received $data');

    // Verify that the message belongs to the current chat
    if (data['from'] != chatService.userTarget.uid) return;

    _addMessageToChatBody(data['from'], data['message']);
  }

  _loadHistory(String uidTarget) async {
    List<Message> chat = await chatService.getChat(uidTarget);

    for (Message m in chat) {
      _addMessageToChatBody(m.from, m.message, isPrecharged: true);
    }
    setState(() {});
  }
}
