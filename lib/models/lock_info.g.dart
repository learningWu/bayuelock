// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lock_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LockInfo _$LockInfoFromJson(Map<String, dynamic> json) {
  return LockInfo(
      json['key'] as int,
      json['lockCard'] as String,
      json['location'] as String,
      json['coord'] as int,
      json['remark'] as String,
      json['status'] as String,
      json['createName'] as String,
      json['createTime'] as String,
      json['updatedName'] as String,
      json['updateTime'] as String);
}

Map<String, dynamic> _$LockInfoToJson(LockInfo instance) => <String, dynamic>{
      'key': instance.key,
      'lockCard': instance.lockCard,
      'location': instance.location,
      'coord': instance.coord,
      'remark': instance.remark,
      'status': instance.status,
      'createName': instance.createName,
      'createTime': instance.createTime,
      'updatedName': instance.updatedName,
      'updateTime': instance.updateTime
    };
