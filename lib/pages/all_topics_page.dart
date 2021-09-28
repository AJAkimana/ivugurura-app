import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/widget/topic_list_view.dart';
import 'package:provider/provider.dart';

class AllTopicsPage extends StatefulWidget {

  @override
  _AllTopicsPageState createState() => _AllTopicsPageState();
}

class _AllTopicsPageState extends State<AllTopicsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics'),
        actions: <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.tune))],
      ),
      body: TopicListView(
        repository: Provider.of<Repository>(context),
      ),
    );
  }
}
