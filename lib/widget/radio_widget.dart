import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/models/audio.dart';
import 'package:ivugurura_app/core/utils/constants.dart';

import 'audio_player_widget.dart';

class RadioWidget extends StatefulWidget {
  final Audio audio;
  final double top;
  final double? height;
  final Color color;
  const RadioWidget({
    Key? key,
    required this.audio,
    this.height,
    this.top = 0,
    this.color = Colors.transparent
  }):super(key: key);

  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  bool _play = false;
  Audio currentPlayingAudio = radios[0];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      left: 0,
      right: 0,
      top: widget.top,
      height: widget.height,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40), color: widget.color),
        child: Column(
          children: <Widget>[
            SizedBox(height: screenHeight * 0.01),
            Text(
              currentPlayingAudio.title ?? '',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir'),
            ),
            Text(
              currentPlayingAudio.author ?? '',
              style: TextStyle(fontSize: 20),
            ),
            AudioPlayerWidget(
              mediaUrl: currentPlayingAudio.mediaLink ?? '',
              isRadio: true,
              play: _play,
              onPlay: () {
                setState(() {
                  _play = !_play;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: radios.length,
                itemBuilder: (BuildContext context, int index) {
                  Audio theAudio = radios[index];
                  Color displayColor = currentPlayingAudio == theAudio
                      ? Colors.deepOrangeAccent
                      : Colors.black54;
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {},
                        leading: Text(
                          '${index + 1}.',
                          style: TextStyle( fontSize: 20, color: displayColor),
                        ),
                        title: Text(
                          ' ${theAudio.title}',
                          style: TextStyle( fontSize: 20, color: displayColor),
                        ),
                        subtitle: Text(
                          ' ${theAudio.author}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600, color: displayColor),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            onPlayAudio(radios[index]);
                          },
                          icon: Icon(
                            _play&&currentPlayingAudio==radios[index] ? Icons.pause_circle_filled_outlined : Icons.play_circle_fill_outlined,
                            color: displayColor,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.white,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void onPlayAudio(Audio audio){
    setState(() {
      if(currentPlayingAudio!=audio) {
        currentPlayingAudio = audio;
      }
      _play = true;
    });
  }
}
