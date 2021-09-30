import 'package:json_annotation/json_annotation.dart';

part 'audio.g.dart';

@JsonSerializable()
class Audio{
  String? title;
  String? slug;
  String? author;
  String? mediaLink;
  String? actionDate;
  String? type;

  Audio({
    this.title,
    this.slug,
    this.author,
    this.mediaLink,
    this.actionDate,
    this.type
  });

  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);

  Map<String, dynamic> toJson() => _$AudioToJson(this);
}

class AudioList {}
