import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MusicPlayer extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String audioPath;
  final bool isRadio;

  const MusicPlayer(
      {Key? key,
      required this.audioPlayer,
      required this.audioPath,
      this.isRadio = false})
      : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  AudioPlayer get _audioPlayer => widget.audioPlayer;
  bool get _isRadio => widget.isRadio;
  Duration duration = new Duration();
  Duration position = new Duration();
  bool _isPlaying = false;
  bool isPaused = false;
  bool isRepeat = false;
  Color color = Colors.black;
  List<IconData> icons = [Icons.play_circle_fill, Icons.pause];

  @override
  void initState() {
    _audioPlayer.onDurationChanged.listen((dur) {
      if (!_isRadio) {
        setState(() {
          duration = dur;
        });
      }
    });
    _audioPlayer.onAudioPositionChanged.listen((pos) {
      setState(() {
        position = pos;
      });
    });
    _audioPlayer.setUrl(widget.audioPath);
    _audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        position = Duration(seconds: 0);
        _isPlaying = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(position.toString().split('.')[0],
                    style: TextStyle(fontSize: 16)),
                Text(duration.toString().split('.')[0],
                    style: TextStyle(fontSize: 16))
              ],
            ),
          ),
          slider(),
          _buildButtons()
        ],
      ),
    );
  }

  Widget btnStart() {
    return IconButton(
      padding: const EdgeInsets.only(bottom: 10),
      icon: _isPlaying
          ? Icon(Icons.play_circle_fill, size: 50, color: Colors.blue)
          : Icon(Icons.pause, size: 50, color: Colors.blue),
      onPressed: () {
        if (_isPlaying) {
          _audioPlayer.pause();
          setState(() {
            _isPlaying = false;
          });
        } else {
          _audioPlayer.play(widget.audioPath);
          setState(() {
            _isPlaying = true;
          });
        }
      },
    );
  }

  Widget btnPrev() {
    return IconButton(
      icon: Icon(Icons.skip_previous, size: 20, color: Colors.black),
      onPressed: () {},
    );
  }

  Widget btnNext() {
    return IconButton(
      icon: Icon(Icons.skip_next, size: 20, color: Colors.black),
      onPressed: () {},
    );
  }

  Widget slider() {
    return Slider(
      activeColor: Colors.red,
      inactiveColor: Colors.grey,
      value: _isRadio ? 100 : position.inSeconds.toDouble(),
      min: 0.0,
      max: _isRadio ? 100 : duration.inSeconds.toDouble(),
      onChanged: (double value) {
        if (!_isRadio) {
          setState(() {
            Duration newDuration = Duration(seconds: value.toInt());
            _audioPlayer.seek(newDuration);
          });
        }
      },
    );
  }

  Widget _buildButtons() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[btnPrev(), btnStart(), btnNext()],
      ),
    );
  }
}
