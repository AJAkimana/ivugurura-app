import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/page_layout.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/pages/onboarding_page.dart';
import 'package:ivugurura_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? hasAlreadySetUp;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Downloader
  await FlutterDownloader.initialize(debug: true);
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'kn', supportedLocales: ['kn', 'en', 'sw', 'fr']);
  final prefs = await SharedPreferences.getInstance();
  hasAlreadySetUp = prefs.getBool(HAS_SET);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
      LocalizedApp(delegate, StoreProvider(store: appStore, child: MyApp())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final String appTitle = 'Reformation/Ubugorozi';

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    final StatefulWidget homeScreen;
    if (hasAlreadySetUp != null && hasAlreadySetUp as bool) {
      homeScreen = PageLayout(
          page: HomePage(), title: translate('app.title'), useLayout: true);
    } else {
      homeScreen = OnBoardingPage();
    }
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: translate('app.title'),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey.shade300,
            primarySwatch: Colors.indigo),
        home: homeScreen,
        routes: {'home': (_) => homeScreen},
      ),
    );
  }
}
