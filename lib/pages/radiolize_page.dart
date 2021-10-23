import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ivugurura_app/core/models/audio.dart';
import 'package:ivugurura_app/utils/app_colors.dart' as appColors;
import 'package:ivugurura_app/widget/audio_player_widget.dart';
import 'package:ivugurura_app/widget/player_widget.dart';
import 'package:ivugurura_app/widget/radio_widget.dart';

class RadiolizePage extends StatefulWidget {
  final Audio audio;

  const RadiolizePage({Key? key, required this.audio}) : super(key: key);

  @override
  _RadiolizePageState createState() => _RadiolizePageState();
}

class _RadiolizePageState extends State<RadiolizePage> {
  bool _play = true;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWeight = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: appColors.audioBluishBackground,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight / 2,
            child: Container(
              color: appColors.audioBlueBackground,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text('Radiolize'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                  // audioPlayer.stop();
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                )
              ],
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
          RadioWidget(
              audio: widget.audio,
              top: screenHeight / 3,
              height: screenHeight * 0.4,
            color: Colors.blueGrey,
          )
        ],
      ),
    );
  }
}
