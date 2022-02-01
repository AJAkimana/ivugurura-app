import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/widget/audio_list_view.dart';
import 'package:provider/provider.dart';

class AudioPlayerPage extends StatefulWidget{
  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage>{
  @override
  Widget build(BuildContext context) {
     return AudioListView(repository: Provider.of<Repository>(context));
  }
}
