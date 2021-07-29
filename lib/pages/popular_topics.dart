import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:ivugurura_app/core/models.dart';
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
          _buildHeading("Popular topics"),
          _buildListTopics(context, Colors.blue.shade300),
          _buildListTopics(context, Colors.red.shade300),
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
          child: StoreConnector<AppState, BaseState<Topic>>(
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
                  loop: false,
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
                                // child: Image.asset('assets/reformation.jpg', fit: BoxFit.cover, height: 210),
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
  Widget topicsWidget = InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => OneTopicViewPage()
      ));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  'The Danger In Flesh Foods',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Text('Dear brothers and sisters, it is our pleasure to get to you this writing about the danger resulted from flesh foods.')
              ],
            ),
          )
        ],
      ),
    ),
  );
  Widget topicsWithStore = StoreConnector<AppState, BaseState<Topic>>(
    distinct: true,
    onInitialBuild: (store){},
    converter: (store) => store.state.carouselTopicState,
    builder: (context, topicsState){
      return Text('data');
    },
  );
  return topicsWidget;
}