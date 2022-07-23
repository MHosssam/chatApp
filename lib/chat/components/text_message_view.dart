import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

class TextMessageView extends StatelessWidget {
  final TextMessage textMessage;
  final int messageWidth;

  const TextMessageView({
    Key? key,
    required this.textMessage,
    required this.messageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.green.shade500,
      child: Text(
        textMessage.text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
