import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/models/category.dart';
import 'package:ivugurura_app/core/models/home_content.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/page_layout.dart';
import 'package:ivugurura_app/core/redux/actions/category_actions.dart';
import 'package:ivugurura_app/core/redux/actions/setting_actions.dart';
import 'package:ivugurura_app/core/redux/actions/topic_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/res/assets.dart';
import 'package:ivugurura_app/core/res/text_styles.dart';
import 'package:ivugurura_app/core/rounded_container.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/network_image.dart';
import 'package:ivugurura_app/widget/topic_list_item.dart';

import 'all_topics_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BaseState<HomeContent, HomeContentObject>>(
        distinct: true,
        onInitialBuild: (store) {
          fetchHomeContents(context);
        },
        converter: (store) => store.state.homeContent,
        builder: (context, homeContentState) {
          final mostReads = homeContentState.theObject!.mostReads;
          final categories = homeContentState.theObject!.categories;
          final recents = homeContentState.theObject!.recents;
          if (homeContentState.loading) {
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
          if (homeContentState.error != '') {
            return DisplayError(error: homeContentState.error, onTryAgain: (){
              fetchHomeContents(context);
            },);
          } else {
            return Scaffold(
              backgroundColor: Colors.grey.shade300,
              body: ListView(
                children: <Widget>[
                  MostReadTopics(topics: mostReads),
                  const SizedBox(height: 10.0),
                  _buildHeading(translate('app.recent_topics')),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TopicListItem(topic: recents[index]);
                    },
                  ),
                  _buildHeading(translate('app.category_browse')),
                  Container(
                    width: double.infinity,
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index){
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PageLayout(
                                        title: 'title',
                                        page: AllTopicsPage(category: categories[index]))));
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blueGrey,
                                ),
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: 100,
                                height: 50,
                              ),
                              SizedBox(height: 10),
                              Text(categories[index].name??'')
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
        }
    );
  }
}

Padding _buildHeading(String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(title, style: shadedTitle),
        ),
        MaterialButton(
          elevation: 0,
          textColor: Colors.white,
          color: Colors.indigo,
          height: 0,
          child: Icon(Icons.keyboard_arrow_right),
          minWidth: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          padding: const EdgeInsets.all(2.0),
          onPressed: () {},
        )
      ],
    ),
  );
}


class MostReadTopics extends StatelessWidget {
  final List<Topic> topics;

  const MostReadTopics({Key? key, required this.topics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
        height: 270,
        borderRadius: BorderRadius.circular(0),
        color: Colors.indigo,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                translate('app.most_read_topics'),
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Swiper(
                pagination: SwiperPagination(margin: const EdgeInsets.only()),
                viewportFraction: 0.9,
                itemCount: topics.length,
                autoplay: true,
                loop: true,
                itemBuilder: (context, index) {
                  Topic topic = topics[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedContainer(
                      borderRadius: BorderRadius.circular(4.0),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(
                              topic.title,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.blueAccent,
                              child: PNetworkImage(
                                "$IMAGE_PATH/${topic.coverImage}",
                                fit: BoxFit.cover,
                                height: 210,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ))
            ]
        )
    );
  }
}
