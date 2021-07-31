import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/redux/actions/topic_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/res/assets.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/display_loading.dart';
import 'package:ivugurura_app/widget/network_image.dart';

class OneTopicViewPage extends StatefulWidget{
  final String topicSlug;

  OneTopicViewPage({
    Key? key,
    required this.topicSlug
  }):super(key: key);
  @override
  _OneTopicViewPageState createState() => _OneTopicViewPageState();
}

class _OneTopicViewPageState extends State<OneTopicViewPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Topic details')),
      body: StoreConnector<AppState, BaseState<Topic, TopicDetail>>(
        distinct: true,
        onInitialBuild: (store){
          fetchTopicDetail(widget.topicSlug);
        },
        converter: (store) => store.state.topicDetailState,
        builder: (context, topicDetail){
          if(topicDetail.loading){
            return DisplayLoading();
          }
          if(topicDetail.error!=''){
            return DisplayError();
          }
          if(topicDetail.theObject!.title.isEmpty){
            return Text('Nothing to display');
          }
          else{
            Topic topic = topicDetail.theObject!;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 300,
                        width: double.infinity,
                        child: PNetworkImage(
                            '$IMAGE_PATH/${topic.coverImage}',
                            fit: BoxFit.cover),
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
                        Text(topic.title, style: Theme.of(context).textTheme.headline4),
                        Divider(),
                        SizedBox(height: 10.0),
                        Html(data: topic.content)
                        // Text(
                        //   textAlign: TextAlign.justify,
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      )
    );
  }
}