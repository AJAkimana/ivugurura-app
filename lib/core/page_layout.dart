import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/keep_alive.dart';
import 'package:ivugurura_app/pages/audio_player.dart';
import 'package:ivugurura_app/pages/popular_topics.dart';
import 'package:ivugurura_app/pages/topics_page.dart';
import 'package:ivugurura_app/utils/oval_right_clipper.dart';

class PageLayout extends StatefulWidget {
  final String title;
  final Widget page;
  final bool useLayout;
  const PageLayout(
      {Key? key,
      required this.title,
      required this.page,
      this.useLayout = false})
      : super(key: key);
  @override
  _PageLayoutState createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Color(0xff172347);
  final Color active = Color(0xffcdd2d7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _key.currentState!.openDrawer();
          },
        ),
      ),
      drawer: _buildDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AlwaysAliveWidget(
            child: widget.page,
          )
        ],
      ),
    );
  }

  _buildDrawer() {
    return ClipPath(
      clipper: OverRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildRow(TopicsPage(), Icons.home, "Home"),
                  _buildDivider(),
                  _buildRow(
                      PopularTopicsPage(), Icons.read_more, "Christianity", useLayout: true),
                  _buildDivider(),
                  _buildRow(PopularTopicsPage(), Icons.read_more,
                      "People well-being", useLayout: true),
                  _buildDivider(),
                  _buildRow(
                      PopularTopicsPage(), Icons.read_more, "The prophecy", useLayout: true),
                  _buildDivider(),
                  _buildRow(PopularTopicsPage(), Icons.read_more, "Healthy", useLayout: true),
                  _buildDivider(),
                  _buildRow(AudioPlayer(), Icons.radio, "Radio", useLayout: true),
                  _buildDivider(),
                  _buildRow(AudioPlayer(), Icons.music_note, "Audio", useLayout: true),
                  _buildDivider(),
                  _buildRow(
                      PopularTopicsPage(), Icons.contact_mail, "Contact us", useLayout: true),
                  _buildDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(color: active);
  }

  Widget _buildRow(Widget page, IconData icon, String title,
      {bool useLayout = false}) {
    final TextStyle textStyle = TextStyle(color: active, fontSize: 16.0);
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(icon, color: active),
            SizedBox(width: 10),
            Text(title, style: textStyle)
          ],
        ),
      ),
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) {
                  if(widget.useLayout || useLayout){
                    print('The code executed');
                    return PageLayout(title: title, page: page);
                  }
                  return page;
                }
            )
        );
      },
    );
  }
}
