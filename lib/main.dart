import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/page_layout.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/pages/onboarding_page.dart';
import 'package:ivugurura_app/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    print('===>Notification id: ${notification.audioId}');
    return true;
  });

  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en', supportedLocales: ['en', 'kn', 'sw', 'fr']);
  runApp(
      LocalizedApp(delegate, StoreProvider(store: appStore, child: MyApp())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final String appTitle = 'Reformation Voice';
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    Widget landingScreen = PageLayout(
        page: HomePage(), title: translate('app.title'), useLayout: true);
    final state = StoreProvider.of<AppState>(context).state.settingState;
    if (!state.theObject!.hasSet) {
      landingScreen = OnBoardingPage();
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
            primarySwatch: Colors.indigo,
            accentColor: Colors.red),
        home: landingScreen,
        routes: {
          'home': (_) => landingScreen
          // 'view_one_topic': (context) => OneTopicViewPage()
        },
      ),
    );
  }
}
