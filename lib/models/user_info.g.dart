// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(json['userId'] as int, json['name'] as String,
      json['avatar'] as String, json['describe'] as String)
    ..phone = json['phone'] as String;
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'describe': instance.describe
    };
