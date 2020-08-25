// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleInfo _$RoleInfoFromJson(Map<String, dynamic> json) {
  return RoleInfo(
      json['key'] as int, json['name'] as String, json['remark'] as String);
}

Map<String, dynamic> _$RoleInfoToJson(RoleInfo instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'remark': instance.remark
    };
