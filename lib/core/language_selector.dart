import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/models/language.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelector extends StatefulWidget {
  LanguageSelector({Key? key}) : super(key: key);

  @override
  LanguageSelectorState createState() => LanguageSelectorState();
}

class LanguageSelectorState extends State<LanguageSelector> {
  late Language _lang;

  _selectLanguage(Language language) {
    setState(() {
      SharedPreferences.getInstance().then((SharedPreferences sp){
        sp.setString('shortName', language.short_name);
        _lang = _getLanguageInfo(language.short_name);
      });
    });
  }

  Language _getLanguageInfo(String shortName) {
    return systemLanguages.firstWhere((lang) {
      return lang.short_name == shortName;
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      String shortName = (sp.getString('shortName') ?? 'kn');
      _lang= _getLanguageInfo(shortName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _lang,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: systemLanguages
          .map((Language lang) {
        return DropdownMenuItem(
          value: lang,
          child: Text(lang.name),
        );
      }).toList(),
    );
  }
}
