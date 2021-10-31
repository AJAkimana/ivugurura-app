import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor: lightMode
          ? Color(0xe1f5fe).withOpacity(1.0)
          : Color(0x042a49).withOpacity(1.0),
      body: Center(
          child: Text('Ijwi ry Ubugorozi', style: TextStyle(fontSize: 72))),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future<SharedPreferences> initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    final prefs = await SharedPreferences.getInstance();

    return prefs;
  }
}
