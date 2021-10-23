import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/data/dependencies_provider.dart';
import 'package:ivugurura_app/core/keep_alive.dart';
import 'package:ivugurura_app/core/redux/actions/category_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
// import 'package:ivugurura_app/widget/audio_player_widget.dart';
// import 'package:ivugurura_app/pages/music_player_page.dart';
import 'package:ivugurura_app/pages/radiolize_page.dart';
import 'package:ivugurura_app/pages/all_topics_page.dart';
import 'package:ivugurura_app/pages/audio_player_page.dart';
import 'package:ivugurura_app/pages/home_page.dart';
import 'package:ivugurura_app/pages/setting_page.dart';
import 'package:ivugurura_app/utils/oval_right_clipper.dart';
import 'package:ivugurura_app/widget/dots_loader.dart';
// import 'package:provider/provider.dart';

import 'models/audio.dart';
import 'models/category.dart';

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
  String _menuValue = '';

  @override
  Widget build(BuildContext context) {
    if (!widget.useLayout) {
      return DependenciesProvider(
          child: AlwaysAliveWidget(
        child: widget.page,
      ));
    }
    return DependenciesProvider(
        child: Scaffold(
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.radio),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.radio),
                    title: Text('Radiolize'),
                    onTap: () {
                      onGoToPage(RadiolizePage(audio: audioRadiolize),
                          translate('title.radio'));
                    },
                  ),
                  value: 'radiolize',
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(translate('title.setting')),
                    onTap: () {
                      onGoToPage(SettingPage(), translate('title.setting'));
                    },
                  ),
                  value: 'setting',
                )
              ];
            },
            onSelected: (value){
             setState(() {
               _menuValue = value;
             });
            },
          )
        ],
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
    ));
  }

  Widget _buildDrawer() {
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
                  _buildRow(AllTopicsPage(), Icons.home, translate('app.home')),
                  _buildDivider(),
                  _buildCategoriesList(),
                  _buildDivider(),
                  _buildRow(RadiolizePage(audio: audioRadiolize), Icons.radio,
                      translate('title.radio')),
                  _buildDivider(),
                  _buildRow(AudioPlayerPage(), Icons.music_note,
                      translate('title.audio')),
                  _buildDivider(),
                  _buildRow(HomePage(), Icons.contact_mail,
                      translate('title.contact_us')),
                  _buildDivider(),
                  _buildRow(SettingPage(), Icons.settings,
                      translate('title.setting')),
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

  Widget _buildCategoriesList() {
    final TextStyle textStyle = TextStyle(color: active, fontSize: 16.0);
    return StoreConnector<AppState, BaseState<Category, CategoriesList>>(
        distinct: true,
        onInitialBuild: (store) {},
        converter: (store) => store.state.categoriesState,
        builder: (context, categoriesState) {
          if (categoriesState.loading && categoriesState.theList!.length == 0) {
            return DotsLoader();
          }
          if (categoriesState.error != '') {
            return Text('Something went wrong');
          }
          if (categoriesState.theList!.length < 1) {
            return Text('Not data');
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoriesState.theList!.length,
            itemBuilder: (BuildContext context, int index) {
              Category category = categoriesState.theList![index];
              print(category.language);
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PageLayout(
                              title: 'title',
                              page: AllTopicsPage(category: category))));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.read_more, color: active),
                      SizedBox(width: 10),
                      Text(category.name as String, style: textStyle)
                    ],
                  ),
                ),
              );
            },
          );
        });
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
        onGoToPage(page, title);
      },
    );
  }

  void onGoToPage(Widget page, String title) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PageLayout(title: title, page: page)));
  }
}
