import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:ivugurura_app/core/models/category.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/redux/actions/topic_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/res/assets.dart';
import 'package:ivugurura_app/core/res/text_styles.dart';
import 'package:ivugurura_app/core/rounded_container.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/pages/one_topic_view.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/display_loading.dart';
import 'package:ivugurura_app/widget/network_image.dart';
import 'package:ivugurura_app/widget/recent_topic_item.dart';

class PopularTopicsPage extends StatefulWidget{
  @override
  _PopularTopicsPageState createState() => _PopularTopicsPageState();
}

class _PopularTopicsPageState extends State<PopularTopicsPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: ListView(
        children: <Widget>[
          _buildFeacturedTopics(),
          const SizedBox(height: 10.0),
          _buildHeading("Recent topics"),
          _buildListTopics(context, Colors.blue.shade300),
          // _buildListTopics(context, Colors.red.shade300),
          _buildHeading("Browse by category"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade200,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade200,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade200,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade200,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade200,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

RoundedContainer _buildFeacturedTopics(){
  return RoundedContainer(
    height: 270,
    borderRadius: BorderRadius.circular(0),
    color: Colors.indigo,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Most Read Posts',
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        Expanded(
          child: StoreConnector<AppState, BaseState<Topic, CarouselTopic>>(
            distinct: true,
            onInitialBuild: (store){
              fetchTopics();
            },
            converter: (store) => store.state.carouselTopicState,
            builder: (context, topicsState){
              print(topicsState.error);
              List<Topic> allTopics = topicsState.theList!;
              if(topicsState.loading){
                return DisplayLoading();
              }
              if(topicsState.error != ''){
                return DisplayError();
              }
              if(topicsState.theList!.length < 1){
                return Text('No data to display', style: TextStyle(color: Colors.white),);
              }else{
                return Swiper(
                  pagination: SwiperPagination(margin: const EdgeInsets.only()),
                  viewportFraction: 0.9,
                  itemCount: topicsState.theList!.length,
                  autoplay: true,
                  loop: true,
                  itemBuilder: (context, index){
                    Topic topic = allTopics[index];
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
                );
              }
            },
          )
        )
      ],
    ),
  );
}

Padding _buildHeading(String title){
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          padding: const EdgeInsets.all(2.0),
          onPressed: () {},
        )
      ],
    ),
  );
}

Widget _buildListTopics(BuildContext context, Color color){
  return StoreConnector<AppState, BaseState<Topic, RecentTopic>>(
    distinct: true,
    onInitialBuild: (store){
      fetchTopics(category: 'recent');
    },
    converter: (store) => store.state.recentTopicState,
    builder: (context, recentTopicsState){
      List<Topic> recentTopics = recentTopicsState.theList!;
      if(recentTopicsState.loading){
        return DisplayLoading();
      }
      if(recentTopicsState.error!=''){
        return DisplayError();
      }
      if(recentTopicsState.theList!.length < 1){
        return Text('Not data to display');
      }
      return  ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
          itemCount: recentTopics.length,
          itemBuilder: (BuildContext context, int index){
            return RecentTopicItem(topic: recentTopics[index]);
          },
      );
    },
  );
}