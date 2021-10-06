import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/widget/audio_list_view.dart';
import 'package:ivugurura_app/widget/player_widget.dart';
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

     return Scaffold(
       body: SafeArea(
         child: SingleChildScrollView(
           physics: NeverScrollableScrollPhysics(),
           child: AudioListView(repository: Provider.of<Repository>(context))
         ),
       ),
     );
  }
}


Widget _progress(){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text('00:00', style: TextStyle(fontSize: 15.0, color: Colors.white)),
      Expanded(
        child: Divider(height: 5, color: Colors.white),
      ),
      SizedBox(width: 3,),
      Text('05:24', style: new TextStyle(fontSize: 15.0, color: Colors.white))
    ],
  );
}
