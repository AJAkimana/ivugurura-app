import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/data/dependencies_provider.dart';
import 'package:ivugurura_app/core/keep_alive.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/pages/about_us.dart';
import 'package:ivugurura_app/pages/offline_downloads.dart';
import 'package:ivugurura_app/pages/radiolize_page.dart';
import 'package:ivugurura_app/pages/all_topics_page.dart';
import 'package:ivugurura_app/pages/audio_player_page.dart';
import 'package:ivugurura_app/pages/setting_page.dart';
import 'package:ivugurura_app/utils/app_colors.dart';
import 'package:ivugurura_app/utils/oval_right_clipper.dart';

import 'models/category.dart';
import 'models/home_content.dart';

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
  String menuValue = '';

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
            onSelected: (value) {
              setState(() {
                menuValue = value;
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
              color: appPrimaryColor, boxShadow: [BoxShadow(color: Colors.black45)]),
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
                  // _buildRow(HomePage(), Icons.contact_mail,
                  //     translate('title.contact_us')),
                  // _buildDivider(),
                  _buildRow(OfflineDownloads(), Icons.download,
                      translate('title.downloads')),
                  _buildDivider(),
                  _buildRow(SettingPage(), Icons.settings,
                      translate('title.setting')),
                  _buildDivider(),
                  _buildRow(About(), Icons.people,
                      translate('title.about_us')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(color: subTitleText);
  }

  Widget _buildCategoriesList() {
    final TextStyle textStyle = TextStyle(color: subTitleText, fontSize: 16.0);
    return StoreConnector<AppState, BaseState<HomeContent, HomeContentObject>>(
        distinct: true,
        onInitialBuild: (store) {},
        converter: (store) => store.state.homeContent,
        builder: (context, homeContentState) {
          final categories = homeContentState.theObject!.categories;
          if (homeContentState.loading) {
            return CircularProgressIndicator();
          }
          if (homeContentState.error != '') {
            return Text(translate('app.error_title'));
          }
          if (categories.length < 1) {
            return Text(translate('app.no_data'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              Category category = categories[index];
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
                      Icon(Icons.read_more, color: subTitleText),
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
    final TextStyle textStyle = TextStyle(color: subTitleText, fontSize: 16.0);
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(icon, color: subTitleText),
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

  void onGoToPage(Widget page, String title, {bool setPop=true}) {
    if(setPop){
      Navigator.pop(context);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PageLayout(title: title, page: page)));
  }
}
