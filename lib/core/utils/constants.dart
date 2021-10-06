import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/models/language.dart';

const bool isLocal = false;
const String BASE_REMOTE_URL = "https://reformationvoice.org";
const String BASE_LOCAL_URL = "http://192.168.8.100:5600";

const BASE_URL = isLocal ? BASE_LOCAL_URL : BASE_REMOTE_URL;

const String API_APP_URL = "$BASE_URL/api/v1";

const String IMAGE_PATH = "$BASE_URL/images";
const String AUDIO_PATH = "$BASE_URL/songs/";

const String topicsUrl = "$API_APP_URL/topics";
const String categoriesUrl = "$API_APP_URL/categories";

const Color primaryColor = Colors.indigo;
const Color secondaryColor = Color(0xfff12bb8);
const Color bgColor = Color(0xffF9E0E3);
TextStyle titleHeadingStyle({Color color = secondaryColor}) => TextStyle(
  color: color,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

enum ILanguage { en, kn, sw}

List<Language> systemLanguages = [
  Language(name: 'English', short_name: 'en'),
  Language(name: 'Kinyarwanda', short_name: 'kn'),
  Language(name: 'Kiswahili', short_name: 'sw')
];

Language getLanguageInfo({String? shortName}) {
  return systemLanguages.firstWhere((lang) {
    return lang.short_name == shortName;
  });
}

const String LANG_SHORT_NAME = 'shortName';
const String THEME_DARK = 'isDark';
