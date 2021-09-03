import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ivugurura_app/core/keep_alive.dart';
import 'package:ivugurura_app/core/redux/actions/category_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/pages/audio_player.dart';
import 'package:ivugurura_app/pages/home_page.dart';
import 'package:ivugurura_app/pages/setting_page.dart';
import 'package:ivugurura_app/pages/topics_page.dart';
import 'package:ivugurura_app/utils/oval_right_clipper.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/display_loading.dart';

import 'models/category.dart';

class PageLayout extends StatefulWidget {
  final String title;
  final Widget page;
  final bool useLayout;
  const PageLayout({
    Key? key,
    required this.title,
    required this.page,
    this.useLayout = false
  }) : super(key: key);
  @override
  _PageLayoutState createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Color(0xff172347);
  final Color active = Color(0xffcdd2d7);

  @override
  Widget build(BuildContext context) {
    if(!widget.useLayout){
      return AlwaysAliveWidget(
        child: widget.page,
      );
    }
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
                  _buildCategoriesList(context),
                  _buildDivider(),
                  _buildRow(AudioPlayer(), Icons.radio, "Radio"),
                  _buildDivider(),
                  _buildRow(AudioPlayer(), Icons.music_note, "Audio"),
                  _buildDivider(),
                  _buildRow(
                      HomePage(), Icons.contact_mail, "Contact us"),
                  _buildDivider(),
                  _buildRow(
                      SettingPage(), Icons.settings, "Setting"),
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

  Widget _buildCategoriesList(BuildContext context){
    final TextStyle textStyle = TextStyle(color: active, fontSize: 16.0);
    return StoreConnector<AppState, BaseState<Category, CategoriesList>>(
        distinct: true,
        onInitialBuild: (store){
            fetchCategories(context);
        },
        converter: (store) => store.state.categoriesState,
        builder: (context, categoriesState){
          if(categoriesState.loading && categoriesState.theList!.length == 0){
            return DisplayLoading();
          }
          if(categoriesState.error!=''){
            return DisplayError();
          }
          if(categoriesState.theList!.length < 1){
            return Text('Not data');
          }
          return  ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoriesState.theList!.length,
            itemBuilder: (BuildContext context, int index){
              Category category = categoriesState.theList![index];
              return InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.read_more, color: active),
                      SizedBox(width: 10),
                      Text(category.name as String,  style: textStyle)
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Widget _buildRow(Widget page, IconData icon, String title) {
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_)=> PageLayout(title: title, page: page)
            )
        );
      },
    );
  }
}
