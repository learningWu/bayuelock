import 'package:json_annotation/json_annotation.dart';

part 'lock_info.g.dart';


@JsonSerializable()
class LockInfo extends Object {

  @JsonKey(name: 'key')
  int key;

  @JsonKey(name: 'lockCard')
  String lockCard;

  @JsonKey(name: 'location')
  String location;

  @JsonKey(name: 'coord')
  int coord;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'createName')
  String createName;

  @JsonKey(name:'createTime')
  String createTime;

  @JsonKey(name:'updatedName')
  String updatedName;

  @JsonKey(name:'updateTime')
  String updateTime;

  LockInfo(this.key,this.lockCard,this.location,this.coord,this.remark,this.status,
      this.createName,this.createTime,this.updatedName,this.updateTime,);

  factory LockInfo.fromJson(Map<String, dynamic> srcJson) => _$LockInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LockInfoToJson(this);

}