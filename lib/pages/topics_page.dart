import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ivugurura_app/core/models/category.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/core/utils/mocked_data.dart';
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
                        tabs: buildCategoriesHeader(
                            categoriesState.theList as List<Category>),
                        onTap: (index){
                          print('Fetch data based on index $index');
                        },
                      ),
                    ),
                    body: TabBarView(
                      children: buildCategoriesTabs(
                          categoriesState.theList as List<Category>),
                    ),
                  )
              )
          );
        }
        );
  }
}
