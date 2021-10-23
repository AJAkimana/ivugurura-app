// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeContent _$HomeContentFromJson(Map<String, dynamic> json) {
  return HomeContent(
    recents: (json['recents'] as List<dynamic>)
        .map((e) => Topic.fromJson(e as Map<String, dynamic>))
        .toList(),
    categories: (json['categories'] as List<dynamic>)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList(),
    mostReads: (json['mostReads'] as List<dynamic>)
        .map((e) => Topic.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$HomeContentToJson(HomeContent instance) =>
    <String, dynamic>{
      'recents': instance.recents,
      'categories': instance.categories,
      'mostReads': instance.mostReads,
    };
