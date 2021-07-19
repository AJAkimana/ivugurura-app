import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class User{
  String names, username, email;
  int role;
  bool isActive;
  @JsonKey(name: 'profile_image')
  String profileImage;

  User(this.names, this.username, this.email, this.profileImage, this.role, this.isActive);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

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

@JsonSerializable()
class Language{
  String name;

  Language({this.name = ''});
  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}