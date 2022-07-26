import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class ChatVm extends GetxController {
  bool isRecording = false;
  var record = Record();
  List<types.Message> messages = [];
  final user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final messageText = TextEditingController();

  void loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messagesData = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    messages = messagesData;
    update();
  }

  void addMessage(types.Message message) {
    messages.insert(0, message);
    update();
  }

  // void handleFileSelection() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //   );

  //   if (result != null && result.files.single.path != null) {
  //     final message = types.FileMessage(
  //       author: user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: const Uuid().v4(),
  //       mimeType: lookupMimeType(result.files.single.path!),
  //       name: result.files.single.name,
  //       size: result.files.single.size,
  //       uri: result.files.single.path!,
  //     );
  //     addMessage(message);
  //   }
  // }

  void handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final message = types.ImageMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      addMessage(message);
    }
  }

  void handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;
      if (message.uri.startsWith('http')) {
        try {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );
          messages[index] = updatedMessage;

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          messages[index] = updatedMessage;
        }
      }
      await OpenFile.open(localPath);
    }
    update();
  }

  void handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );
    messages[index] = updatedMessage;
    update();
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    addMessage(textMessage);
  }

  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";
  late AnimationController animationController;

  bool showDelete = false;
  bool isCancelled(Offset offset, BuildContext context) {
    return (offset.dx >= (MediaQuery.of(context).size.width * 0.2));
  }

  Future<void> onLongPressDown() async {
    isRecording = true;
    animationController.forward();
    update();
  }

  Future<void> onLongPressEnd(recordDetails, context) async {
    timer?.cancel();
    timer = null;
    startTime = null;
    recordDuration = "00:00";
    var filePath = await record.stop();

    if (isCancelled(recordDetails.localPosition, context)) {
      showDelete = true;

      Timer(const Duration(milliseconds: 1440), () async {
        animationController.reverse();
        showDelete = false;
        isRecording = false;
        File(filePath!).delete();
            update();

      });
    } else {
      animationController.reverse();

      isRecording = false;
      final message = types.FileMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(filePath!),
        name: 'Record',
        size: filePath.length,
        uri: filePath,
      );
      addMessage(message);
    }
    update();
  }

  Future<void> onLongPress() async {
    var hasPermission = await Record().hasPermission();
    if (hasPermission) {
      record = Record();
      await record.start();
      startTime = DateTime.now();
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final minDur = DateTime.now().difference(startTime!).inMinutes;
        final secDur = DateTime.now().difference(startTime!).inSeconds % 60;
        String min = minDur < 10 ? "0$minDur" : minDur.toString();
        String sec = secDur < 10 ? "0$secDur" : secDur.toString();

        recordDuration = "$min:$sec";
      });
    }
    update();
  }
}
