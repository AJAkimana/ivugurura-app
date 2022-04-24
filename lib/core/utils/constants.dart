import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ivugurura_app/core/models/audio.dart';
import 'package:ivugurura_app/core/models/language.dart';
import 'package:ivugurura_app/core/models/social_media.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool isLocal = false;
const String BASE_REMOTE_URL = "https://reformationvoice.org";
const String BASE_LOCAL_URL = "http://192.168.88.46:5600";

const BASE_URL = isLocal ? BASE_LOCAL_URL : BASE_REMOTE_URL;

const String API_APP_URL = "$BASE_URL/api/v1";

const String IMAGE_PATH = "$BASE_URL/images";
const String AUDIO_PATH = "$BASE_URL/songs";

const String topicsUrl = "$API_APP_URL/topics";
const String categoriesUrl = "$API_APP_URL/categories";
const String homeContentUrl = "$API_APP_URL/manage/home/contents";

const Color primaryColor = Colors.indigo;
const Color secondaryColor = Color(0xfff12bb8);
const Color bgColor = Color(0xffF9E0E3);
TextStyle titleHeadingStyle({Color color = secondaryColor}) => TextStyle(
      color: color,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );

enum ILanguage { en, kn, sw }

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
const HAS_SET = 'hasSet';

Audio audioRadiolize = Audio(
    title: "Ijwi ry'ubugorozi",
    author: 'Radiolize',
    mediaLink: 'https://studio18.radiolize.com/radio/8220/radio.mp3'
);

List<Audio> radios = [
  Audio(
      title: "Ijwi ry'ubugorozi",
      author: 'RadioLize',
      mediaLink: 'https://studio18.radiolize.com/radio/8220/radio.mp3'
  ),
  Audio(
      title: "Radio(Burundi)",
      author: 'RadioLize',
      mediaLink: 'https://my4.radiolize.com/radio/8020/radio.mp3'
  ),
  Audio(
      title: "Radio(Congo)",
      author: 'RadioKing',
      mediaLink: 'https://listen.radioking.com/radio/461093/stream/516359'
  )
];

Future<String> getLangFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return (prefs.getString(LANG_SHORT_NAME) ?? 'kn');
}

const String youtubeChannel = 'https://www.youtube.com/channel/UCCzVYqdLwgNMLMsP-NKNnIQ';
const String fbPage = 'https://www.youtube.com/channel/UCCzVYqdLwgNMLMsP-NKNnIQ';
const String twitterPage = 'https://www.youtube.com/channel/UCCzVYqdLwgNMLMsP-NKNnIQ';
const String flickPage = 'https://www.youtube.com/channel/UCCzVYqdLwgNMLMsP-NKNnIQ';
const String igPage = 'https://www.youtube.com/channel/UCCzVYqdLwgNMLMsP-NKNnIQ';

Map<String, List<SocialMedia>> socialMedias = {
  'en':<SocialMedia>[
    SocialMedia(
        title: 'Youtube',
        url: 'https://youtube.com/channel/UCCzVYqdLwgNMLMsP-NKNnIQ',
        iconData: FontAwesomeIcons.youtube,
        language: systemLanguages[0]
    ),
    SocialMedia(
        title: 'Facebook',
        url: 'https://facebook.com/ivugurura.ubugorozi.10',
        iconData: FontAwesomeIcons.facebookF,
        language: systemLanguages[0]
    ),
    SocialMedia(
        title: 'Twitter',
        url: 'https://twitter.com/Rev_Reformation',
        iconData: FontAwesomeIcons.twitter,
        language: systemLanguages[0]
    ),
    SocialMedia(
        title: 'Instagram',
        url: 'https://instagram.com/reformation_voice',
        iconData: FontAwesomeIcons.instagram,
        language: systemLanguages[0]
    ),
  ],
  'kn':<SocialMedia>[
    SocialMedia(
        title: 'Youtube',
        url: 'https://youtube.com/channel/UCCzVYqdLwgNMLMsP-NKNnIQ',
        iconData: FontAwesomeIcons.youtube,
        language: systemLanguages[1]
    ),
    SocialMedia(
        title: 'Facebook',
        url: 'https://facebook.com/ivugurura.ubugorozi.10',
        iconData: FontAwesomeIcons.facebookF,
        language: systemLanguages[1]
    ),
    SocialMedia(
        title: 'Twitter',
        url: 'https://twitter.com/Rev_Reformation',
        iconData: FontAwesomeIcons.twitter,
        language: systemLanguages[1]
    ),
    SocialMedia(
        title: 'Instagram',
        url: 'https://instagram.com/reformation_voice',
        iconData: FontAwesomeIcons.instagram,
        language: systemLanguages[1]
    ),
  ],
  'sw':<SocialMedia>[
    SocialMedia(
        title: 'Youtube',
        url: 'https://youtube.com/channel/UC0YYf2qv2gUhueHvStXBYwQ',
        iconData: FontAwesomeIcons.youtube,
        language: systemLanguages[2]
    ),
    SocialMedia(
        title: 'Facebook',
        url: 'https://facebook.com/ivugurura.ubugorozi.10',
        iconData: FontAwesomeIcons.facebookF,
        language: systemLanguages[2]
    ),
    SocialMedia(
        title: 'Twitter',
        url: 'https://twitter.com/Rev_Reformation',
        iconData: FontAwesomeIcons.twitter,
        language: systemLanguages[2]
    ),
    SocialMedia(
        title: 'Instagram',
        url: 'https://instagram.com/reformation_voice',
        iconData: FontAwesomeIcons.instagram,
        language: systemLanguages[2]
    ),
  ]
};
