import 'package:chat/chat/chat_vm.dart';
import 'package:chat/chat/components/record_button.dart';
import 'package:chat/chat/widget/record_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    final ChatVm controller = Get.put(ChatVm());

    super.initState();
    controller.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    controller.isRecording = false;
    super.initState();
    // to get prev chat
    // controller.loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatVm>(
        builder: (controller) {
          return Chat(
            messages: controller.messages,
            onMessageTap: controller.handleMessageTap,
            onPreviewDataFetched: controller.handlePreviewDataFetched,
            onSendPressed: controller.handleSendPressed,
            disableImageGallery: true,
            showUserAvatars: true,
            showUserNames: true,
            user: controller.user,
            fileMessageBuilder: (types.FileMessage audio,
                    {required int messageWidth}) =>
                RecordView(audio: audio),
            customBottomWidget: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
             
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => controller.handleImageSelection(),
                    child: const Icon(Icons.photo_camera),
                  ),
                  const Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 6),
                      child: RecordButton()),
                            if (!controller.isRecording)
  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black26,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          maxLines: null,
                          cursorColor: Colors.black87,
                          controller: controller.messageText,
                          decoration: const InputDecoration(
                            hintText: 'Aa',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (controller.messageText.text.isNotEmpty) {
                        controller.handleSendPressed(
                          types.PartialText(text: controller.messageText.text),
                        );
                        controller.messageText.clear();
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
