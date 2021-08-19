import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ivugurura_app/core/models/language.dart';
import 'package:ivugurura_app/core/models/setting.dart';
import 'package:ivugurura_app/core/redux/actions/setting_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelector extends StatefulWidget {
  LanguageSelector({Key? key}) : super(key: key);

  @override
  LanguageSelectorState createState() => LanguageSelectorState();
}

class LanguageSelectorState extends State<LanguageSelector> {
  ILanguage? _iLanguage;

  void _selectLanguage(ILanguage? iLanguage) async {
    Language lang = getLanguageInfo(iLang: iLanguage);
    Setting setting = Setting(language: lang);
    changeSettings(setting: setting);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BaseState<Setting, SettingInfo>>(
        distinct: true,
        onInitialBuild: (store) {
          // loadSettings();
        },
        converter: (store) => store.state.settingState,
        builder: (context, settingState) {
          Setting setting = settingState.theObject as Setting;
          if (setting.language != null) {
            _iLanguage = setting.language!.iLanguage;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: systemLanguages
                .map((language) => ListTile(
                      title: Text(language.name),
                      leading: Radio<ILanguage>(
                          value: language.iLanguage as ILanguage,
                          groupValue: _iLanguage,
                          onChanged: _selectLanguage),
                    ))
                .toList(),
          );
        });
  }
}
