import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/widget/network_image.dart';

class TopicListItem extends StatelessWidget {
  final Topic topic;
  const TopicListItem({
    Key? key,
    required this.topic
  }) : super(key: key);

  DateTime get dateTime => DateTime.parse(topic.createdAt as String);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6)
      ),
      child: InkWell(
        onTap: (){},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(topic.title, style: textTheme.subtitle1),
                  ),
                  const SizedBox(width: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: PNetworkImage("$IMAGE_PATH/${topic.coverImage}", height: 50, width: 50),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(topic.description, style: textTheme.bodyText2),
              Text(DateFormat('MMM d yyyy').format(dateTime))
            ],
          ),
        ),
      ),
    );
  }
}
