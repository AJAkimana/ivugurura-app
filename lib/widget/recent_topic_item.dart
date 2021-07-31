import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/page_layout.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/pages/one_topic_view.dart';
import 'package:ivugurura_app/widget/network_image.dart';
import 'package:truncate/truncate.dart';

class RecentTopicItem extends StatelessWidget{
  final Topic topic;

  RecentTopicItem({
    Key? key,
    required this.topic
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=>  PageLayout(
                  title: topic.title,
                  page: OneTopicViewPage(topicSlug: topic.slug),
                  useLayout: false,
              ),
          )
        );
      },
      child: Padding(
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
              child: PNetworkImage(
                "$IMAGE_PATH/${topic.coverImage}",
                fit: BoxFit.cover,
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
                  Html(
                    data: truncate(topic.content, 150, omission: '...'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}