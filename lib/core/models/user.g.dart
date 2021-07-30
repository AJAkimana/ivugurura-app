// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

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
