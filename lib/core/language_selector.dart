import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ivugurura_app/core/models/language.dart';
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
    final prefs = await SharedPreferences.getInstance();
    Language lang = getLanguageInfo(iLang: iLanguage);
    setState(() {
      _iLanguage = iLanguage;
      prefs.setString('shortName', lang.short_name);
    });
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String shortName = (prefs.getString('shortName') ?? 'kn');
    Language lang = getLanguageInfo(shortName: shortName);
    setState(() {
      _iLanguage = lang.iLanguage;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: systemLanguages.map((language) =>ListTile(
        title: Text(language.name),
        leading: Radio<ILanguage>(
          value: language.iLanguage as ILanguage,
          groupValue: _iLanguage,
          onChanged: _selectLanguage
        ),
      ) ).toList(),
    );
  }
}
