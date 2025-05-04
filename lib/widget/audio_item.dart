import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/models/audio.dart';

class AudioItem extends StatelessWidget {
  final Audio audio;
  final int audioIndex;
  final Function onSetCurrent;
  final Function onDownloadCurrent;
  final Audio currentAudio;

  const AudioItem({
    Key? key,
    required this.audio,
    required this.audioIndex,
    required this.onSetCurrent,
    required this.onDownloadCurrent,
    required this.currentAudio
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color displayColor = currentAudio.slug == audio.slug
        ? Colors.deepOrangeAccent
        : Colors.white;
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            onSetCurrent();
          },
          leading: Text(
            '${audioIndex + 1}',
            style: TextStyle(
                color: displayColor,
                fontSize: 20),
          ),
          title: Text(
            audio.title!,
            style: TextStyle(color: displayColor, fontSize: 16),
          ),
          subtitle: Text(
            audio.author!,
            style: TextStyle(
                color: displayColor, fontSize: 14, fontWeight: FontWeight.w200),
          ),
          trailing: IconButton(
              onPressed: (){
                onDownloadCurrent(audio);
              },
              icon: Icon(Icons.download, color: displayColor)),
        ),
        Divider(
          height: 1,
          color: Colors.white,
        )
      ],
    );
  }
}
