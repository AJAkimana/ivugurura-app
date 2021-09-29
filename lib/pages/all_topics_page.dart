import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/core/models/category.dart';
import 'package:ivugurura_app/widget/topic_list_view.dart';
import 'package:provider/provider.dart';

class AllTopicsPage extends StatefulWidget {
  final Category? category;
  AllTopicsPage({Key? key, this.category});
  @override
  _AllTopicsPageState createState() => _AllTopicsPageState();
}

class _AllTopicsPageState extends State<AllTopicsPage> {
  @override
  Widget build(BuildContext context) {
    int categoryId = 0;
    String title = translate('app.topics');
    if(widget.category is Category){
      title = widget.category!.name!;
      categoryId = widget.category!.id!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.tune))],
      ),
      body: TopicListView(
        repository: Provider.of<Repository>(context),
        categoryId: categoryId,
      ),
    );
  }
}
