import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/extensions/duration_media_extension.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String mediaUrl;
  final bool isRadio;
  const AudioPlayerWidget(
      {Key? key, required this.mediaUrl, this.isRadio = false})
      : super(key: key);
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool _play = true;
  String _currentPosition = '';

  @override
  Widget build(BuildContext context) {
    return AudioWidget.network(
      url: widget.mediaUrl,
      play: _play,
      onReadyToPlay: (total) {
        setState(() {
          _currentPosition = widget.isRadio
              ? Duration().mmSSFormat
              : '${Duration().mmSSFormat} / ${total.mmSSFormat}';
        });
      },
      onPositionChanged: (current, total) {
        setState(() {
          _currentPosition = widget.isRadio
              ? current.mmSSFormat
              : '${current.mmSSFormat} / ${total.mmSSFormat}';
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(14),
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _play = !_play;
                });
              },
              child: Icon(
                _play ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 44,
              ),
            ),
          ),
          Text(_currentPosition,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
