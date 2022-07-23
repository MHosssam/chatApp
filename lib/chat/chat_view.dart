import 'package:chat/chat/chat_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    final ChatVm controller = Get.put(ChatVm());
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
            // onAttachmentPressed: _handleAtachmentPressed,
            onMessageTap: controller.handleMessageTap,
            onPreviewDataFetched: controller.handlePreviewDataFetched,
            onSendPressed: controller.handleSendPressed,
            disableImageGallery: true,
            showUserAvatars: true,
            showUserNames: true,
            user: controller.user,
            customBottomWidget: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => controller.handleFileSelection(),
                      child: const Icon(Icons.attach_file),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => controller.handleRecord(),
                    child: const Icon(Icons.mic),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => controller.handleImageSelection(),
                      child: const Icon(Icons.photo_camera),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: controller.messageText,
                          decoration: const InputDecoration(
                            hintText: 'Aa',
                            contentPadding: EdgeInsets.all(8),
                            border: InputBorder.none,
                            // suffixIcon: Icon(
                            //   Icons.search,
                            //   color: Colors.grey,
                            // ),
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
