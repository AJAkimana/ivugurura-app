import 'package:ivugurura_app/core/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

import 'language.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic{
  String title, slug, coverImage, description;
  String? content, createdAt;
  Language? language;
  Category? category;
  Topic({
    this.title = '',
    this.slug = '',
    this.coverImage = '',
    this.description = '',
    this.content,
    this.createdAt,
    this.language,
    this.category
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

class RecentTopic{}

class CarouselTopic{}

class TopicDetail{}

class CategoryTopic{}
