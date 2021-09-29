import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ivugurura_app/core/models/category.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/redux/actions/topic_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/core/utils/mocked_data.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/dots_loader.dart';
import 'package:ivugurura_app/widget/no_display_data.dart';
import 'package:ivugurura_app/widget/recent_topic_item.dart';
import 'package:ivugurura_app/widget/topic_item.dart';

class TopicsPage extends StatefulWidget {
  @override
  TopicsPageState createState() => TopicsPageState();
}

class TopicsPageState extends State<TopicsPage> {
  int pageLength = 0;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        distinct: true,
        onInitialBuild: (store) {},
        converter: (store) => store.state,
        builder: (context, state) {
          final categoriesState =
              state.categoriesState as BaseState<Category, CategoriesList>;
          pageLength = categoriesState.theList!.length + 1;
          final categories = categoriesState.theList!;
          return DefaultTabController(
              initialIndex: currentIndex,
              length: pageLength,
              child: Theme(
                  data: ThemeData(
                      primaryColor: primaryColor,
                      appBarTheme: AppBarTheme(
                        color: primaryColor,
                        textTheme: TextTheme(headline6: titleHeadingStyle()),
                        iconTheme: IconThemeData(color: bgColor),
                        actionsIconTheme: IconThemeData(color: bgColor),
                      )),
                  child: Scaffold(
                    backgroundColor: Theme.of(context).buttonColor,
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text('Topics', style: TextStyle(color: bgColor)),
                      leading: Icon(Icons.category),
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.search), onPressed: () {})
                      ],
                      bottom: TabBar(
                        isScrollable: true,
                        labelColor: bgColor,
                        indicatorColor: secondaryColor,
                        unselectedLabelColor: bgColor,
                        tabs: buildCategoriesHeader(categories),
                        onTap: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                    body: TabBarView(
                      children: buildCategoriesTabs(categories, currentIndex),
                    ),
                  )));
        });
  }

  Widget _buildListTopics(dynamic category) {
    return StoreConnector<AppState, BaseState<Topic, CategoryTopic>>(
      distinct: true,
      onInitialBuild: (store) {
        fetchTopics(context, category: category);
      },
      converter: (store) => store.state.categoryTopic,
      builder: (context, categoryTopicsState) {
        List<Topic> categoryTopics = categoryTopicsState.theList!;
        // print(categoryTopics);
        // print(category);
        // print(currentIndex);
        if (categoryTopicsState.loading) {
          return DotsLoader();
        }
        if (categoryTopicsState.error != '') {
          return DisplayError(error: categoryTopicsState.error);
        }
        if (categoryTopicsState.theList!.length < 1) {
          return NoDisplayData();
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: categoryTopics.length,
          itemBuilder: (BuildContext context, int index) {
            return RecentTopicItem(topic: categoryTopics[index]);
          },
        );
      },
    );
  }

  List<Widget> buildCategoriesTabs(List<Category> categories, int currIndex) {
    Widget firstCategory = Center(
      child: Text('Recent topics',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4),
    );
    if (currIndex == 0) {
      firstCategory = _buildListTopics('recent');
    }
    final theList = <Widget>[firstCategory];
    for (var category in categories) {
      Widget currCategory = Center(
        child: Text(category.name ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4),
      );
      if (currIndex != 0) {
        currCategory = _buildListTopics(category.id);
      }
      theList.add(currCategory);
    }
    return theList;
  }

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
}
