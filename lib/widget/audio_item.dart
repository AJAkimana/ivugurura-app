import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ivugurura_app/core/models/audio.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AudioItem extends StatelessWidget {
  final Audio audio;
  final int audioIndex;
  final Function onSetCurrent;
  final Audio currentAudio;

  const AudioItem(
      {Key? key,
      required this.audio,
      required this.audioIndex,
      required this.onSetCurrent,
      required this.currentAudio})
      : super(key: key);

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
              onPressed: () { },
              icon: Icon(Icons.download, color: displayColor)),
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

  Future<void> _addToDownload() async {
    String mediaUrl = "$AUDIO_PATH/${(audio!.mediaLink?? '')}";
    final dir = await getApplicationDocumentsDirectory();
    var localPath = dir.path + (audio!.title?? '');
    final savedDir = Directory(localPath);

    await savedDir.create(recursive: true).then((value) async {
      String? taskId = await FlutterDownloader.enqueue(
          url: Uri.encodeFull(mediaUrl),
          fileName: audio.title,
          savedDir: localPath,
          showNotification: true,
          openFileFromNotification: false
      );
      print('=========================>TaskId');
      print(taskId);
    });
  }
}
