import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/res/assets.dart';
import 'package:ivugurura_app/widget/network_image.dart';

class OneTopicViewPage extends StatefulWidget{
  @override
  _OneTopicViewPageState createState() => _OneTopicViewPageState();
}

class _OneTopicViewPageState extends State<OneTopicViewPage>{
  static final String path = 'lib/pages/one_topic_view.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Topic details')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
           Stack(
             children: <Widget>[
               Container(
                 height: 300,
                 width: double.infinity,
                 // child: PNetworkImage(images[0], fit: BoxFit.cover),
                 child: Image.asset('assets/reformation.jpg', fit: BoxFit.cover),
               ),
               Positioned(
                 bottom: 20.0,
                 left: 20.0,
                 right: 20.0,
                 child: Row(
                   children: <Widget>[
                     Icon(Icons.slideshow, color: Colors.white),
                     Text('Prophecy', style: TextStyle(color: Colors.white))
                   ],
                 ),
               )
             ],
           ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: Text('10/07/2021')),
                      IconButton(onPressed: () {}, icon: Icon(Icons.access_time))
                    ],
                  ),
                  Text('The Danger In Flesh Foods', style: Theme.of(context).textTheme.headline4),
                  Divider(),
                  SizedBox(height: 10.0),
                  Text(
                    'Dear brothers and sisters, it is our pleasure to get to you this writing about the danger resulted from flesh foods. Although it seems like opposing the will of many due to the popularity of this kind of diet, the time reaches that this danger should be made plain. Often, meat is brought on tables in many families but they continue endanging their life in so doing.',
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}