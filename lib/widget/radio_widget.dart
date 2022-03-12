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
            SizedBox(height: screenHeight * 0.05),
            Text(
              widget.audio.title ?? '',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir'),
            ),
            Text(
              widget.audio.author ?? '',
              style: TextStyle(fontSize: 20),
            ),
            AudioPlayerWidget(
              mediaUrl: widget.audio.mediaLink ?? '',
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
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {},
                        leading: Text(
                          '${index + 1}.',
                          style: TextStyle( fontSize: 20),
                        ),
                        title: Text(
                          ' ${theAudio.title}',
                          style: TextStyle( fontSize: 20),
                        ),
                        subtitle: Text(
                          ' ${theAudio.author}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
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
}
