import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/core/utils/mocked_data.dart';
import 'package:ivugurura_app/widget/topic_item.dart';

class TopicsPage extends StatefulWidget{

  @override
  TopicsPageState createState() => TopicsPageState();
}

class TopicsPageState extends State<TopicsPage>{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Theme(
        data: ThemeData(
          primaryColor: primaryColor,
          appBarTheme: AppBarTheme(
            color: primaryColor,
            textTheme: TextTheme(
              headline6: titleHeadingStyle()
            ),
            iconTheme: IconThemeData(color: bgColor),
            actionsIconTheme: IconThemeData(color: bgColor),
          )
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).buttonColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text('Topics', style: TextStyle(color: bgColor)),
            leading: Icon(Icons.category),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.search), onPressed: (){})
            ],
            bottom: TabBar(
              isScrollable: true,
              labelColor: bgColor,
              indicatorColor: secondaryColor,
              unselectedLabelColor: bgColor,
              tabs: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("For You"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Health"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: mockedTopics.length,
                itemBuilder: (context, index){
                  return TopicItem(topic: mockedTopics[index]);
                },
                separatorBuilder: (context, index) => const SizedBox(height: 4),
              ),
              Container(
                child: Text("Tab 2"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}