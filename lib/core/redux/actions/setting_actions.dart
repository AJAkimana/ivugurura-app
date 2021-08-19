import 'package:ivugurura_app/core/models/setting.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base_action.dart';
import '../store.dart';

Future<void> loadSettings() async {
  DispatchedAction<Setting, SettingInfo> dispatchedAction;

  dispatchedAction = DispatchedAction<Setting, SettingInfo>();

  // appStore.dispatch(dispatchedAction.pending());
  // try{
    final prefs = await SharedPreferences.getInstance();
    String shortName = (prefs.getString('shortName') ?? 'kn');
    bool isDark = (prefs.getBool('theme') ?? false);
    Setting settings = Setting(
        language: getLanguageInfo(shortName: shortName),
      isDark: isDark
    );
    appStore.dispatch(dispatchedAction.fulfilled(settings, dataType: 'object'));
  // } catch (error){
  //   print('{=======================Setting');
  //   print(error.toString());
  //   print('=========================}');
  //   appStore.dispatch(dispatchedAction.rejected(error.toString()));
  // }
}