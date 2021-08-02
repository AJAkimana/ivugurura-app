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
    content: json['content'] as String?,
    createdAt: json['createdAt'] as String?,
    language: json['language'] == null
        ? null
        : Language.fromJson(json['language'] as Map<String, dynamic>),
    category: json['category'] == null
        ? null
        : Category.fromJson(json['category'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'title': instance.title,
      'slug': instance.slug,
      'coverImage': instance.coverImage,
      'description': instance.description,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'language': instance.language,
      'category': instance.category,
    };
