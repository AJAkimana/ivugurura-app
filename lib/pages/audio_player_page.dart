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
     double height = MediaQuery.of(context).size.height;
     double topHeight = height * 0.4;

     return Scaffold(
       body: SafeArea(
         child: SingleChildScrollView(
           physics: NeverScrollableScrollPhysics(),
           child: Stack(
             children: <Widget>[
               Column(
                 children: <Widget>[
                   Stack(
                     children: <Widget>[
                       Container(
                         height: topHeight,
                         width: MediaQuery.of(context).size.width,
                         child: Image.asset('assets/audio.jpeg', fit: BoxFit.cover),
                       ),
                     ],
                   ),
                   Container(
                     height: height * 0.6,
                     decoration: BoxDecoration(
                       gradient: LinearGradient(
                         begin: Alignment.topLeft,
                         end: Alignment.bottomRight,
                         stops: [0, 0.5, 1],
                         colors: [
                           Color(0xFF014F82),
                           Color(0xff00395f),
                           Color(0xFF001726)
                         ]
                       )
                     ),
                     child: Column(
                       children: <Widget>[
                         SizedBox(height: 25),
                         Text(' Buffering... ', style: TextStyle(color: Colors.white, fontSize: 25)),
                         _progress(),
                         Expanded(
                           child: AudioListView(repository: Provider.of<Repository>(context))
                         )
                       ],
                     ),
                   )
                 ],
               ),
               Positioned(
                 left: MediaQuery.of(context).size.width * 0.15,
                 top: topHeight - 35,
                 child: FractionalTranslation(
                   translation: Offset(0, 0.5),
                   child: playerWidget(),
                 ),
               )
             ],
           ),
         ),
       ),
     );
  }
  playerWidget(){
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          height: 35,
          width: MediaQuery.of(context).size.width * 0.7,
          margin: EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 5)],
            borderRadius: BorderRadius.circular(50),
            color: Colors.blue
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.fast_rewind,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                  icon: Icon(
                    Icons.fast_forward,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
              IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
        )
      ],
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
