import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black26,
        ),
        child:  Padding(
          padding:const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            maxLines: null,
            cursorColor: Colors.black87,
            controller: controller,
            decoration:const InputDecoration(
              hintText: 'Aa',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
