import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/models/topic.dart';

class RecentTopicItem extends StatelessWidget{
  final Topic topic;

  RecentTopicItem({
    Key? key,
    required this.topic
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade300
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  topic.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text('Dear brothers and sisters, it is our pleasure to get to you this writing about the danger resulted from flesh foods.')
              ],
            ),
          )
        ],
      ),
    );
  }
}