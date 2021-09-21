import 'package:flutter/cupertino.dart';
import 'package:ivugurura_app/core/models/category.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/widget/topic_item.dart';

List<Topic> mockedTopics = [
  Topic(title: 'How to Seem Like You Always Have Your Shot Together'),
  Topic(title: 'Does Dry is January Actually Improve Your Health?'),
  Topic(title: 'You do hire a designer to make something. You hire them.'),
];

const List<Map> articles = [
  {
    "title": "How to Seem Like You Always Have Your Shot Together",
    "author": "Jonhy Vino",
    "time": "4 min read",
  },
  {
    "title": "Does Dry is January Actually Improve Your Health?",
    "author": "Jonhy Vino",
    "time": "4 min read",
  },
  {
    "title": "You do hire a designer to make something. You hire them.",
    "author": "Jonhy Vino",
    "time": "4 min read",
  },
  {
    "title": "How to Seem Like You Always Have Your Shot Together",
    "author": "Jonhy Vino",
    "time": "4 min read",
  },
  {
    "title": "How to Seem Like You Always Have Your Shot Together",
    "author": "Jonhy Vino",
    "time": "4 min read",
  },
  {
    "title": "Does Dry is January Actually Improve Your Health?",
    "author": "Jonhy Vino",
    "time": "4 min read",
  },
  {
    "title": "You do hire a designer to make something. You hire them.",
    "author": "Jonhy Vino",
    "time": "4 min read",
  },
  {
    "title": "How to Seem Like You Always Have Your Shot Together",
    "author": "Jonhy Vino",
    "time": "4 min read",
  },
];
List<Widget> buildCategoriesHeader(List<Category> categories) {
  final theList = <Widget>[
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("For You"),
    ),
  ];
  for (var category in categories) {
    theList.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(category.name ?? ''),
    ));
  }
  return theList;
}

List<Widget> buildCategoriesTabs(List<Category> categories) {
  final theList = <Widget>[
    ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: mockedTopics.length,
      itemBuilder: (context, index){
        return TopicItem(topic: mockedTopics[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 4),
    ),
  ];
  for (var category in categories) {
    theList.add(Container(
      child: Text('Tab ${category.name}'),
    ));
  }
  return theList;
}
