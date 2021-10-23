import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/redux/actions/topic_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/dots_loader.dart';
import 'package:ivugurura_app/widget/network_image.dart';
import 'package:ivugurura_app/core/extensions/string_cap_extension.dart';

class OneTopicViewPage extends StatefulWidget {
  final String topicSlug;

  OneTopicViewPage({Key? key, required this.topicSlug}) : super(key: key);
  @override
  OneTopicViewPageState createState() => OneTopicViewPageState();
}

class OneTopicViewPageState extends State<OneTopicViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, BaseState<Topic, TopicDetail>>(
          distinct: true,
          onInitialBuild: (store) {
            fetchTopicDetail(context, widget.topicSlug);
          },
          converter: (store) => store.state.topicDetailState,
          builder: (context, topicDetail) {
            if (topicDetail.loading) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 10.0,),
                    ],
                  )
              );
            }
            if (topicDetail.error != '') {
              return DisplayError(error: topicDetail.error);
            }
            if (topicDetail.theObject!.title.isEmpty) {
              return Text('Nothing to display');
            } else {
              Topic topic = topicDetail.theObject!;
              DateTime dateTime = DateTime.parse(topic.createdAt as String);
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 150.0,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(topic.title),
                      background: PNetworkImage(
                          '$IMAGE_PATH/${topic.coverImage}',
                          fit: BoxFit.cover),
                    ),
                    actions: <Widget>[
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.category))
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.indigoAccent,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.category, color: Colors.white),
                            Text(topic.category!.name as String,
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                    DateFormat.yMMMMEEEEd().format(dateTime))),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.access_time))
                          ],
                        ),
                        Text(topic.title.inCaps,
                            style: Theme.of(context).textTheme.headline4),
                        Divider(),
                        SizedBox(height: 10.0),
                        Html(data: topic.content),
                        Divider(),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        padding: EdgeInsets.all(20.0),
                        color: Colors.indigoAccent,
                        child: Text(translate('app.related_topics'),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      Topic catTopic = topic.category!.relatedTopics![index];
                      return ListTile(
                        title: Text(
                            catTopic.title.toLowerCase().capitalizeFirstOfEach,
                            style: titleHeadingStyle(color: Colors.black87)),
                        subtitle:
                            Text(catTopic.description.toLowerCase().inCaps),
                        trailing: Container(
                          width: 80.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '$IMAGE_PATH/${catTopic.coverImage}'),
                                  fit: BoxFit.cover)),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OneTopicViewPage(
                                      topicSlug: catTopic.slug)));
                        },
                      );
                    }, childCount: topic.category!.relatedTopics!.length),
                  ),
                ],
              );
            }
          }),
    );
  }
}
