import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/models/language.dart';
import 'package:ivugurura_app/core/models/setting.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base_action.dart';
import '../store.dart';

Future<void> loadSettings(BuildContext context) async {
  DispatchedAction<Setting, SettingInfo> dispatchedAction;

  dispatchedAction = DispatchedAction<Setting, SettingInfo>();

  final prefs = await SharedPreferences.getInstance();
  String shortName = (prefs.getString(LANG_SHORT_NAME) ?? 'kn');
  final language = getLanguageInfo(shortName: shortName);
  final isDark = (prefs.getBool(THEME_DARK) ?? false);
  final hasSet = (prefs.getBool(HAS_SET) ?? false);

  final setting = Setting(language: language, isDark: isDark, hasSet: hasSet);

  appStore.dispatch(dispatchedAction.fulfilled(setting, dataType: 'object'));
  changeLocale(context, setting.language!.short_name);
}

Future<void> changeSettings(BuildContext context, {Setting? setting}) async {
  final prefs = await SharedPreferences.getInstance();
  Language? language = setting!.language;
  if (language != null) {
    prefs.setString(LANG_SHORT_NAME, language.short_name ?? 'kn');
  }
  if (setting.isDark != null) {
    prefs.setBool(THEME_DARK, setting.isDark ?? false);
  }
  if(setting.hasSet!=null){
    prefs.setBool(HAS_SET, setting.hasSet??false);
  }
  await loadSettings(context);
}
