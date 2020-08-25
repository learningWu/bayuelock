// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_permission_apply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomePermissionApply _$HomePermissionApplyFromJson(Map<String, dynamic> json) {
  return HomePermissionApply(
      json['key'] as int,
      json['localtion'] as String,
      json['applyPeople'] as String,
      json['remark'] as String,
      json['status'] as String,
      json['applyTime'] as String);
}

Map<String, dynamic> _$HomePermissionApplyToJson(
        HomePermissionApply instance) =>
    <String, dynamic>{
      'key': instance.key,
      'localtion': instance.localtion,
      'applyPeople': instance.applyPeople,
      'remark': instance.remark,
      'status': instance.status,
      'applyTime': instance.applyTime
    };
