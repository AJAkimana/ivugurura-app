import 'package:ivugurura_app/core/models/language.dart';
import 'package:ivugurura_app/core/models/setting.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base_action.dart';
import '../store.dart';

Future<void> loadSettings() async {
  DispatchedAction<Setting, SettingInfo> dispatchedAction;

  dispatchedAction = DispatchedAction<Setting, SettingInfo>();

  final prefs = await SharedPreferences.getInstance();
  String shortName = (prefs.getString(LANG_SHORT_NAME) ?? 'kn');
  bool isDark = (prefs.getBool(THEME_DARK) ?? false);
  Setting settings =
      Setting(language: getLanguageInfo(shortName: shortName), isDark: isDark);
  appStore.dispatch(dispatchedAction.fulfilled(settings, dataType: 'object'));
}

Future<void> changeSettings({Setting? setting}) async {
  final prefs = await SharedPreferences.getInstance();
  Language? language = setting!.language;
  if(language!=null){
    prefs.setString(LANG_SHORT_NAME, language.short_name as String);
  }
  if(setting.isDark!=null){
    prefs.setBool(THEME_DARK, setting.isDark as bool);
  }
  loadSettings();
}
