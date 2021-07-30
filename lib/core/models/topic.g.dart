// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
