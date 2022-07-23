import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:record/record.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  late Animation<double> buttonScaleAnimation;

  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";
  late Record record;

  bool showDelete = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    buttonScaleAnimation = Tween<double>(begin: 1, end: 2).animate(
        CurvedAnimation(
            parent: widget.controller,
            curve: const Interval(0, .6, curve: Curves.elasticInOut)));
  }

  @override
  void dispose() {
    record.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  bool isCancelled(Offset offset, BuildContext context) {
    return (offset.dx >= (MediaQuery.of(context).size.width * 0.2));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (isRecording)
          Positioned(
            child: Container(
              height: 40,
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
                    showDelete
                        ? const Icon(Icons.delete,
                            color: Color.fromARGB(255, 136, 18, 18))
                        : Text(recordDuration),
                  ],
                ),
              ),
            ),
          ),
        GestureDetector(
          onLongPressDown: (_) {
            setState(() {
              isRecording = true;
            });
            widget.controller.forward();
          },
          onLongPressEnd: (recordDetails) async {
            if (isCancelled(recordDetails.localPosition, context)) {
              timer?.cancel();
              timer = null;
              startTime = null;
              recordDuration = "00:00";
              setState(() {
                showDelete = true;
              });

              Timer(const Duration(milliseconds: 1440), () async {
                widget.controller.reverse();
                var filePath = await record.stop();
                showDelete = false;
                isRecording = false;
                                File(filePath!).delete();

              });
            } else {
              widget.controller.reverse();
              timer!.cancel();
              timer = null;
              startTime = null;
              recordDuration = "00:00";
              await record.stop();
              setState(() {
                isRecording = false;
              });
            }
          },
          onLongPress: () async {
            var hasPermission = await Record().hasPermission();
            if (hasPermission) {
              record = Record();
              await record.start();
              startTime = DateTime.now();
              timer = Timer.periodic(const Duration(seconds: 1), (_) {
                final minDur = DateTime.now().difference(startTime!).inMinutes;
                final secDur =
                    DateTime.now().difference(startTime!).inSeconds % 60;
                String min = minDur < 10 ? "0$minDur" : minDur.toString();
                String sec = secDur < 10 ? "0$secDur" : secDur.toString();
                setState(() {
                  recordDuration = "$min:$sec";
                });
              });
            } else {}
          },
          child: Transform.scale(
            scale: buttonScaleAnimation.value,
            child: Container(
              height: 40,
              width: 40,
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
  }
}
