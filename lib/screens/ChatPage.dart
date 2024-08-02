import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/commons/MyTextField.dart';
import 'package:messaging_app/commons/chatContainer.dart';
import 'package:messaging_app/services/auth/auth_services.dart';
import 'package:messaging_app/services/chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String emailReciver;
  final String receivedId;
  ChatPage({super.key, required this.emailReciver, required this.receivedId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _message = TextEditingController();

//chat& authservices
  final ChatServices chatServices = ChatServices();
  final AuthServices authServices = AuthServices();

  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    Future.delayed(
      Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    _message.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

//sendMessage
  void sendMessage() async {
    if (_message.text.isNotEmpty) {
      await chatServices.sendMessage(widget.receivedId, _message.text);
      _message.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.emailReciver,
        ),
      ),
      body: Column(
        children: [
          //displayMessages
          Expanded(child: _buildListMessages()),

          //messageInput
          _inputMessage(),
        ],
      ),
    );
  }

  Widget _buildListMessages() {
    String senderId = authServices.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: chatServices.getMessages(widget.receivedId, senderId),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text("error ...");
        }
        //loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading ...");
        }
        //listView
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current User 3awd
    bool isCurrentUser = data["senderId"] == authServices.getCurrentUser()!.uid;

    var align =
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        ChatContainer(message: data["message"], isCurrentUser: isCurrentUser)
      ],
    );
  }

  Widget _inputMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 10),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
                focusNode: focusNode,
                myController: _message,
                obscureText: false,
                hintText: "Type message..."),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
