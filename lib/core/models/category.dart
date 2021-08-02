import 'package:json_annotation/json_annotation.dart';

import 'package:ivugurura_app/core/models/language.dart';
import 'package:ivugurura_app/core/models/topic.dart';

part 'category.g.dart';

@JsonSerializable()
class Category{
  String? name, slug;
  Language? language;
  List<Topic>? relatedTopics;

  Category({
    this.name,
    this.slug,
    this.language,
    this.relatedTopics = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}