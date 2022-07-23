
import 'package:chat/chat/chat_view.dart';
import 'package:chat/main_chat/components/chat_item.dart';
import 'package:chat/main_chat/fake_data.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.green[400],
      automaticallyImplyLeading: false,
      title: const Text('Chats'),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
    ),
      body:     Padding(
        padding: const EdgeInsets.only(top:10),
        child: ListView.builder(
            itemCount: chatsData.length,
            itemBuilder: (context, index) {
          return ChatItem(
            chat: chatsData[index],
            press: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatPage(),
              ),
            ),
          );
            },
          ),
      ),
  
   
    );
  }


}