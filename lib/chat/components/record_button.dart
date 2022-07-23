import 'package:chat/chat/chat_vm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    Key? key,
  }) : super(key: key);

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  late Animation<double> buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    final ChatVm controller = Get.put(ChatVm());

    controller.animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ChatVm controller = Get.put(ChatVm());

    buttonScaleAnimation = Tween<double>(begin: 1, end: 1.4).animate(
      CurvedAnimation(
        parent: controller.animationController,
        curve: const Interval(0, .6, curve: Curves.elasticInOut),
      ),
    );
  }

  @override
  void dispose() {
    final ChatVm controller = Get.put(ChatVm());

    controller.record.dispose();
    controller.timer?.cancel();
    controller.timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatVm>(builder: (controller) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          if (controller.isRecording)
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * .72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                color: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(width: 30),
                    Row(
                      children: const [
                        Text("Slide to cancel"),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    const SizedBox(width: 30),
                    controller.showDelete
                        ? const Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 136, 18, 18),
                          )
                        : Text(controller.recordDuration),
                  ],
                ),
              ),
            ),
          GestureDetector(
            onLongPressDown: (_) => controller.onLongPressDown(),
            onLongPressEnd: (recordDetails) =>
                controller.onLongPressEnd(recordDetails, context),
            onLongPress: () => controller.onLongPress(),
            child: Transform.scale(
              scale: buttonScaleAnimation.value,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green[300],
                ),
                child: const Icon(Icons.mic),
              ),
            ),
          )
        ],
      );
    });
  }
}
