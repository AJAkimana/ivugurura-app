import 'package:ivugurura_app/core/models/category.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_content.g.dart';

@JsonSerializable()
class HomeContent{
  List<Topic> recents;
  List<Category> categories;
  List<Topic> mostReads;

  HomeContent({
    this.recents = const [],
    this.categories = const [],
    this.mostReads = const []
  });

  factory HomeContent.fromJson(Map<String, dynamic> json) => _$HomeContentFromJson(json);

  Map<String, dynamic> toJson() => _$HomeContentToJson(this);
}

class HomeContentObject{}