import 'package:ivugurura_app/core/models/language.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting.g.dart';

@JsonSerializable()
class Setting{
  Language? language;
  bool? isDark;
  bool? hasSet;

  Setting({
    this.language,
    this.isDark,
    this.hasSet
  });

  factory Setting.fromJson(Map<String, dynamic> json) => _$SettingFromJson(json);

  Map<String, dynamic> toJson() => _$SettingToJson(this);
}

class SettingInfo{}