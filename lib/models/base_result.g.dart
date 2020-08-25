// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResult _$BaseResultFromJson(Map<String, dynamic> json) {
  return BaseResult(json['data'], json['status'] as int,
      json['message'] as String, json['errors'] as Map<String, dynamic>)
    ..meta = json['meta'] as Map<String, dynamic>;
}

Map<String, dynamic> _$BaseResultToJson(BaseResult instance) =>
    <String, dynamic>{
      'data': instance.data,
      'status': instance.status,
      'message': instance.message,
      'meta': instance.meta,
      'errors': instance.errors
    };
