import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

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