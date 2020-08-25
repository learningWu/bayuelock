import 'package:json_annotation/json_annotation.dart';

part 'home_permission_apply.g.dart';

@JsonSerializable()
class HomePermissionApply extends Object {

  @JsonKey(name: 'key')
  int key;

  @JsonKey(name: 'localtion')
  String localtion;

  @JsonKey(name: 'applyPeople')
  String applyPeople;

  @JsonKey(name: 'remark')
  String remark;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name:'applyTime')
  String applyTime;

  HomePermissionApply(this.key,this.localtion,this.applyPeople,this.remark,this.status,this.applyTime);


  factory HomePermissionApply.fromJson(Map<String, dynamic> srcJson) => _$HomePermissionApplyFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HomePermissionApplyToJson(this);

}