import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/extensions/duration_media_extension.dart';
import 'package:ivugurura_app/core/utils/constants.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String mediaUrl;
  final bool isRadio;
  final bool play;
  final VoidCallback onPlay;
  const AudioPlayerWidget({
    Key? key,
    required this.mediaUrl,
    this.isRadio = false,
    required this.play,
    required this.onPlay
  }): super(key: key);
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  String _currentPosition = '';

  @override
  Widget build(BuildContext context) {
    if (widget.mediaUrl.isNotEmpty || widget.mediaUrl != AUDIO_PATH){
      return AudioWidget.network(
        url: widget.mediaUrl,
        play: widget.play,
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
                onPressed: widget.onPlay,
                child: Icon(
                  widget.play ? Icons.pause : Icons.play_arrow,
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
    return Center(child: Text('Loading,...'));
  }
}
