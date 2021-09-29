import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/pages/one_topic_view.dart';
import 'package:ivugurura_app/widget/network_image.dart';
import 'package:truncate/truncate.dart';
import 'package:ivugurura_app/core/extensions/string_cap_extension.dart';

class TopicListItem extends StatelessWidget {
  final Topic topic;
  const TopicListItem({Key? key, required this.topic}) : super(key: key);

  DateTime get dateTime => DateTime.parse(topic.createdAt as String);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OneTopicViewPage(topicSlug: topic.slug),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(topic.title.toLowerCase().capitalizeFirstOfEach, style: textTheme.headline6),
                  ),
                  const SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(right: 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue.shade300
                      ),
                      child: PNetworkImage(
                        "$IMAGE_PATH/${topic.coverImage}",
                        fit: BoxFit.cover,
                      ),
                    )
                  )
                ],
              ),
              const SizedBox(height: 8),
              Html(data: truncate(topic.content as String, 150, omission: '...')),
              Text(DateFormat('MMM d yyyy').format(dateTime))
            ],
          ),
        ),
      ),
    );
  }
}
