import 'package:flutter/material.dart';
import 'package:ivugurura_app/utils/oval_right_clipper.dart';

class PageLayout extends StatefulWidget{
  @override
  _PageLayoutState createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout>{
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Color(0xff172347);
  final Color active = Color(0xffcdd2d7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Ivugurura n Ubugorozi'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            _key.currentState!.openDrawer();
          },
        ),
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ],
        ),
      ),
    );
  }

  _buildDrawer(){
    return ClipPath(
      clipper: OverRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
            color: primary,
            boxShadow: [BoxShadow(color: Colors.black45)]
          ),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildRow(Icons.home, "Home"),
                  _buildDivider(),
                  _buildRow(Icons.read_more, "Christianity"),
                  _buildDivider(),
                  _buildRow(Icons.read_more, "People well-being"),
                  _buildDivider(),
                  _buildRow(Icons.read_more, "The prophecy"),
                  _buildDivider(),
                  _buildRow(Icons.read_more, "Healthy"),
                  _buildDivider(),
                  _buildRow(Icons.radio, "Radio"),
                  _buildDivider(),
                  _buildRow(Icons.music_note, "Audio"),
                  _buildDivider(),
                  _buildRow(Icons.contact_mail, "Contact us"),
                  _buildDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider(){
    return Divider(color: active);
  }

  Widget _buildRow(IconData icon, String title){
    final TextStyle textStyle = TextStyle(color: active, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: active),
          SizedBox(width: 10),
          Text(title, style: textStyle)
        ],
      ),
    );
  }
}
