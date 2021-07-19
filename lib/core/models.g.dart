// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['names'] as String,
    json['username'] as String,
    json['email'] as String,
    json['profile_image'] as String,
    json['role'] as int,
    json['isActive'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'names': instance.names,
      'username': instance.username,
      'email': instance.email,
      'role': instance.role,
      'isActive': instance.isActive,
      'profile_image': instance.profileImage,
    };

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return Topic(
    title: json['title'] as String,
    slug: json['slug'] as String,
    coverImage: json['coverImage'] as String,
    description: json['description'] as String,
    language: json['language'] == null
        ? null
        : Language.fromJson(json['language'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'title': instance.title,
      'slug': instance.slug,
      'coverImage': instance.coverImage,
      'description': instance.description,
      'language': instance.language,
    };

Language _$LanguageFromJson(Map<String, dynamic> json) {
  return Language(
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
      'name': instance.name,
    };
