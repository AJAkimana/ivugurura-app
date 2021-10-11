import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/data/repository.dart';
// import 'package:ivugurura_app/pages/music_player_page.dart';
import 'package:ivugurura_app/widget/audio_list_view.dart';
// import 'package:ivugurura_app/widget/player_widget.dart';
import 'package:provider/provider.dart';

class AudioPlayerPage extends StatefulWidget{
  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage>{
  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
     double topHeight = height * 0.4;

     return AudioListView(repository: Provider.of<Repository>(context));
  }
}
