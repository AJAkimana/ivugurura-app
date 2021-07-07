import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/keep_alive.dart';

class ViewPage extends StatefulWidget{
  final String title;
  final Widget page;
  final String? path;

  const ViewPage({
    Key? key,
    required this.title,
    required this.page,
    required this.path
  }): super(key: key);

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage>{
  late Offset offset;
  @override
  void initState(){
    super.initState();
    offset = Offset(0,0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.red),
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.code),
            onPressed: (){
              if(offset.dy == 0.9){
                setState(() {
                  offset = Offset(0, 0);
                });
              }else{
                setState(() {
                  offset = Offset(0, 0.9);
                });
              }
            },
          ),
          IconButton(
            icon: kIsWeb? Icon(Icons.share): Platform.isIOS ? Icon(Icons.ios_share):Icon(Icons.share),
            tooltip: 'Share',
            onPressed: (){},
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AlwaysAliveWidget(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              // child: CodeView(filePath: widget.path),
            ),
          ),
          FractionalTranslation(
            translation: offset,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  offset = Offset(0, 0);
                });
              },
              child: AnimatedContainer(
                duration: Duration(microseconds: 500),
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: offset.dy == 0.9? null: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                child: AlwaysAliveWidget(child: widget.page),
              ),
            ),
          )
        ],
      ),
    );
  }
}
