import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/models/language.dart';
import 'package:json_annotation/json_annotation.dart';

part 'social_media.g.dart';

@JsonSerializable()
class SocialMedia{
  String? title;
  String? url;
  IconData? iconData;
  Color? color;
  Language? language;

  SocialMedia({
    this.title,
    this.url,
    this.iconData,
    this.color,
    this.language
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) => _$SocialMediaFromJson(json);

  Map<String, dynamic> toJson() => _$SocialMediaToJson(this);
}
