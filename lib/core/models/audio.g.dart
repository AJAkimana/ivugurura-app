// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Audio _$AudioFromJson(Map<String, dynamic> json) {
  return Audio(
    title: json['title'] as String?,
    slug: json['slug'] as String?,
    author: json['author'] as String?,
    mediaLink: json['mediaLink'] as String?,
    actionDate: json['actionDate'] as String?,
    type: json['type'] as String?,
  );
}

Map<String, dynamic> _$AudioToJson(Audio instance) => <String, dynamic>{
      'title': instance.title,
      'slug': instance.slug,
      'author': instance.author,
      'mediaLink': instance.mediaLink,
      'actionDate': instance.actionDate,
      'type': instance.type,
    };
