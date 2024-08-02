import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatContainer extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatContainer({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCurrentUser ? Colors.green : Colors.blue,
      ),
      child: Text(message),
    );
  }
}
