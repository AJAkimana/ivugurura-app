import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ivugurura_app/core/models/language.dart';
import 'package:ivugurura_app/core/models/setting.dart';
import 'package:ivugurura_app/core/redux/actions/setting_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';

class LanguageSelector extends StatefulWidget {
  LanguageSelector({Key? key}) : super(key: key);

  @override
  LanguageSelectorState createState() => LanguageSelectorState();
}

class LanguageSelectorState extends State<LanguageSelector> {
  Language? _language = systemLanguages[0];

  void _selectLanguage(Language? language) async {
    Setting setting = Setting(language: language);
    changeSettings(context, setting: setting);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BaseState<Setting, SettingInfo>>(
        distinct: true,
        converter: (store) => store.state.settingState,
        builder: (context, settingState) {
          final setting = settingState.theObject;
          if (setting!.language != null) {
            _language = setting.language;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: systemLanguages
                .map((language) => ListTile(
                      title: Text(language.name),
                      leading: Radio<Language>(
                          value: language,
                          groupValue: _language,
                          onChanged: _selectLanguage),
                    ))
                .toList(),
          );
        });
  }
}
