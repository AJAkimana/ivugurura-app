import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/models/audio.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AudioItem extends StatelessWidget {
  final Audio audio;
  final int audioIndex;
  final Function onSetCurrent;
  final Audio currentAudio;

  const AudioItem({
    Key? key,
      required this.audio,
      required this.audioIndex,
      required this.onSetCurrent,
      required this.currentAudio
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap:(){ onSetCurrent();},
          leading: Text(
            '${audioIndex + 1}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          title: Text(
            audio.title!,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          subtitle: Text(
            audio.author!,
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w200),
          ),
          trailing: IconButton(
            onPressed: _launchURL,
            icon: currentAudio.slug == audio.slug
                ? Icon(Icons.share, color: Colors.white)
                : Icon(Icons.share, color: Colors.white),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.white,
        )
      ],
    );
  }

  void _launchURL() async {
    String mLink = audio.mediaLink ?? '';
    String mediaUrl = Uri.encodeFull(AUDIO_PATH + mLink);
    if (!await launch(mediaUrl)) throw 'Could not download ${audio.title}';
  }
}
