import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:ivugurura_app/core/res/assets.dart';
import 'package:ivugurura_app/core/res/text_styles.dart';
import 'package:ivugurura_app/core/rounded_container.dart';
import 'package:ivugurura_app/pages/one_topic_view.dart';
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
            fontSize: 28.0,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        Expanded(
          child: Swiper(
            pagination: SwiperPagination(margin: const EdgeInsets.only()),
            viewportFraction: 0.9,
            itemCount: 4,
            loop: false,
            itemBuilder: (context, index){
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
                          'The Danger In Flesh Foods.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.red,
                          child: Image.asset('assets/reformation.jpg', fit: BoxFit.cover, height: 210),
                          // child: PNetworkImage(
                          //   images[0],
                          //   fit: BoxFit.cover,
                          //   height: 210,
                          // ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
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
  return InkWell(
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
}