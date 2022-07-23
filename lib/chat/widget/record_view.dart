import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:just_audio/just_audio.dart';

class RecordView extends StatefulWidget {
  final FileMessage audio;

  const RecordView({Key? key, required this.audio}) : super(key: key);

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  late AudioPlayer _player;
  AnimationController? lottieController;

  @override
  void initState() {
    _player = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 150,
      color: Colors.green.shade500,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return const CircularProgressIndicator();
                } else if (playing != true) {
                  return InkWell(
                    child: const Icon(
                      Icons.play_arrow,
                      size: 40,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      _player.setAudioSource(
                        ConcatenatingAudioSource(
                          children: [
                            AudioSource.uri(
                              Uri.parse(widget.audio.uri),
                              tag: {
                                'createdAt': widget.audio.createdAt,
                              },
                            ),
                          ],
                        ),
                      );
                      _player.play();
                    },
                  );
                } else if (processingState != ProcessingState.completed) {
                  return InkWell(
                    onTap: _player.pause,
                    child: const Icon(
                      Icons.pause,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                } else {
                  return InkWell(
                    child: const Icon(
                      Icons.play_arrow,
                      size: 40,
                      color: Colors.grey,
                    ),
                    onTap: () => _player.seek(
                      Duration.zero,
                      index: _player.effectiveIndices!.first,
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: Image.asset(
              'assets/images/record-wave.png',
              fit: BoxFit.cover,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
