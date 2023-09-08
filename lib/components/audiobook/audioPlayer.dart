import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:jendela_dbp/components/chapterList.dart';


class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({Key? key}) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final GlobalKey _iconButtonKey = GlobalKey();
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<Duration?>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    // Listen to durationStream and update _audioDuration when it changes
    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _audioDuration = duration;
        });
      }
    });

    _loadAudioFromAsset().then((filePath) {
      _audioPlayer.setFilePath(filePath);
      _audioPlayer.play();
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Duration _currentPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;

  void bottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        context: context,
        builder: (BuildContext context) {
          return const ChapterList();
        });
  }

  void _togglePlayback() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      if (_audioPlayer.playerState.processingState ==
          ProcessingState.completed) {
        await _audioPlayer.seek(Duration.zero);
      }
      await _audioPlayer.play();
    }
  }

  void _skipForward() async {
    // Get the current position of the audio
    final currentPosition =  _audioPlayer.position;

    // Calculate the new position to skip forward by ten seconds
    final newPosition = currentPosition + const Duration(seconds: 10);

    // Seek to the new position
    await _audioPlayer.seek(newPosition);
  }

  void _skipBackward() async {
    // Get the current position of the audio
    final currentPosition =  _audioPlayer.position;

    // Calculate the new position to skip backward by ten seconds
    final newPosition = currentPosition - const Duration(seconds: 10);

    // Seek to the new position
    await _audioPlayer.seek(newPosition);
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
    });
    _audioPlayer.setSpeed(speed);
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours.remainder(60));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  Future<String> _loadAudioFromAsset() async {
    final ByteData data =
        await rootBundle.load('assets/audio/audiobook.wav');
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/audiobook.wav');
    await tempFile.writeAsBytes(data.buffer.asUint8List());
    return tempFile.path;
  }

  void _showPopup(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button =
        _iconButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset buttonPosition =
        button.localToGlobal(Offset.zero, ancestor: overlay);
    final double buttonWidth = button.size.width;
    final double buttonHeight = button.size.height;

    showMenu<double>(
      context: context,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx,
        buttonPosition.dy + buttonHeight,
        overlay.size.width - buttonPosition.dx - buttonWidth,
        overlay.size.height - buttonPosition.dy,
      ),
      items: [
        // Popup menu items here
        const PopupMenuItem(
          value: 0.5,
          child: Text('0.5x'),
        ),
        const PopupMenuItem(
          value: 0.75,
          child: Text('0.75x'),
        ),
        const PopupMenuItem(
          value: 1.0,
          child: Text('normal'),
        ),
        const PopupMenuItem(
          value: 1.25,
          child: Text('1.25x'),
        ),
        const PopupMenuItem(
          value: 1.5,
          child: Text('1.5x'),
        ),
        const PopupMenuItem(
          value: 2.0,
          child: Text('2.0x'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _changePlaybackSpeed(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 25,
          child: Slider(
            onChanged: (value) async {
              _audioPlayer.seek(Duration(seconds: value.toInt()));
            },
            min: 0,
            max: _audioDuration.inSeconds.toDouble(),
            value: _currentPosition.inSeconds.toDouble(),
            activeColor: const Color.fromARGB(255, 235, 127, 35),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(formatTime(_currentPosition)),
            const SizedBox(
              width: 200,
            ),
            Text(formatTime(_audioDuration)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    bottomSheet(context);
                  },
                  icon: const Icon(
                    Icons.list_rounded,
                    color: Color.fromARGB(255, 191, 191, 191),
                    size: 30,
                  )),
              IconButton(
                onPressed: () {
                  _skipBackward();
                },
                icon: const Icon(
                  FontAwesomeIcons.backwardFast,
                  color: Color.fromARGB(255, 191, 191, 191),
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () async {
                  _togglePlayback();
                },
                icon: Icon(
                  _isPlaying
                      ? FontAwesomeIcons.solidCirclePause
                      : FontAwesomeIcons.solidCirclePlay,
                  color: const Color.fromARGB(255, 90, 90, 90),
                  size: 60,
                ),
              ),
              IconButton(
                  onPressed: () {
                    _skipForward();
                  },
                  icon: const Icon(
                    FontAwesomeIcons.forwardFast,
                    color: Color.fromARGB(255, 191, 191, 191),
                    size: 30,
                  )),
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    key: _iconButtonKey,
                    onPressed: () {
                      _showPopup(context);
                    },
                    icon: const Icon(
                      Icons.one_x_mobiledata_outlined,
                      color: Color.fromARGB(255, 191, 191, 191),
                      size: 30,
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
