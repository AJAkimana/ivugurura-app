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
  String shortName = (prefs.getString('shortName') ?? 'kn');
  bool isDark = (prefs.getBool('theme') ?? false);
  Setting settings =
      Setting(language: getLanguageInfo(shortName: shortName), isDark: isDark);
  appStore.dispatch(dispatchedAction.fulfilled(settings, dataType: 'object'));
}

Future<void> changeSettings({Setting? setting}) async {
  DispatchedAction<Setting, SettingInfo> dispatchedAction;

  dispatchedAction = DispatchedAction<Setting, SettingInfo>();

  final prefs = await SharedPreferences.getInstance();
  Language? language = setting!.language;
  if(language!=null){
    prefs.setString('shortName', language.short_name);
  }
  if(setting.isDark!=null){
    prefs.setBool('isDark', setting.isDark as bool);
  }
  loadSettings();
}
