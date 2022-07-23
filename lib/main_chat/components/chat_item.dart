
import 'package:chat/main_chat/fake_data.dart';
import 'package:flutter/material.dart';
class ChatItem extends StatelessWidget {
  final Chat chat;
  final VoidCallback press;

  const ChatItem({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const  EdgeInsets.symmetric(
            horizontal: 10, vertical: 5),
        child: Row(
          children: [
           CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(chat.image),
                ),
            Expanded(
              child: Padding(
                padding:
                 const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(chat.time),
            )
          ],
        ),
      ),
    );
  }
}