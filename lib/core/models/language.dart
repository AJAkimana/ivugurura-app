import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

@JsonSerializable()
class Language{
  String name, short_name;
  ILanguage? iLanguage;

  Language({this.name = '', this.short_name = '', this.iLanguage});
  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}