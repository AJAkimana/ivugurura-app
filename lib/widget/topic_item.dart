import 'package:flutter/material.dart';

import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/utils/constants.dart';

class TopicItem extends StatelessWidget{
  final Topic topic;
  
  TopicItem({
    Key? key, 
    required this.topic
  }):super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Stack(
        children: <Widget>[
          Container(
            width: 90,
            height: 90,
            color: bgColor,
          ),
          Container(
            color: bgColor,
            padding: const EdgeInsets.all(7),
            margin: const EdgeInsets.all(7),
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  color: primaryColor,
                  width: 80.0,
                  child: Image.asset('assets/reformation.jpg', fit: BoxFit.cover),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        topic.title,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: CircleAvatar(radius: 15, backgroundColor: primaryColor,)
                            ),
                            WidgetSpan(child: const SizedBox(width: 5,)),
                            TextSpan(
                                text: 'My chosen folder',
                                style: TextStyle(fontSize: 16.0)
                            ),
                            WidgetSpan(child: const SizedBox(width: 20.0),),
                            WidgetSpan(child: const SizedBox(width: 5.0),),
                            TextSpan(text: 'Read time'),
                          ]
                        )
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}