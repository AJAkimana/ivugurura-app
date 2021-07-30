import 'package:json_annotation/json_annotation.dart';

import 'language.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic{
  String title, slug, coverImage, description;
  Language? language;
  Topic({
    this.title = '',
    this.slug = '',
    this.coverImage = '',
    this.description = '',
    this.language
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

class RecentTopic{}

class CarouselTopic{}
