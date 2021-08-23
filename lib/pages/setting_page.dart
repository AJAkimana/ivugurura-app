import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ivugurura_app/core/custom_alert_dialog.dart';
import 'package:ivugurura_app/core/language_selector.dart';
import 'package:ivugurura_app/core/models/language.dart';
import 'package:ivugurura_app/core/models/setting.dart';
import 'package:ivugurura_app/core/redux/actions/setting_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/res/assets.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  late bool _dark = false;

  Brightness _getBrightness() => _dark ? Brightness.dark : Brightness.light;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
          backgroundColor: _dark ? null : Colors.grey.shade500,
          appBar: AppBar(
            elevation: 0,
            brightness: _getBrightness(),
            iconTheme: IconThemeData(
                color: _dark ? Colors.white : Colors.grey.shade200),
            backgroundColor: Colors.transparent,
            title: Text(
              'Setting',
              style: TextStyle(color: _dark ? Colors.white : Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    setState(() {
                      _dark = !_dark;
                    });
                  },
                  icon: Icon(Icons.mood)),
            ],
          ),
          body: StoreConnector<AppState, BaseState<Setting, SettingInfo>>(
            distinct: true,
            onInitialBuild: (store) {
              loadSettings();
            },
            converter: (store) => store.state.settingState,
            builder: (context, settingState) {
              Setting setting = settingState.theObject as Setting;
              String langName = '';
              if (setting.language != null) {
                langName = setting.language!.name;
              }
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: Colors.purple,
                          child: ListTile(
                            onTap: () {},
                            title: Text(
                              'Ivugurura n Ubugorozi',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(images[0]),
                            ),
                            trailing: Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Card(
                          elevation: 4.0,
                          margin:
                              const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.lock_outlined,
                                    color: Colors.purple),
                                title: Text('Language Set: $langName'),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomAlertDialog(
                                          title: 'Change language',
                                          content: 'Some information',
                                          widget: LanguageSelector(),
                                          onPressOk: (){
                                            Navigator.of(context).pushReplacementNamed('home');
                                          },
                                        );
                                      });
                                },
                              ),
                              _buildDivider(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          )),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
