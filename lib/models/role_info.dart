import 'package:json_annotation/json_annotation.dart';

part 'role_info.g.dart';

@JsonSerializable()

class RoleInfo extends Object
{
  @JsonKey(name: 'key')
  int key;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'remark')
  String remark;

  RoleInfo(this.key, this.name, this.remark);
  factory RoleInfo.fromJson(Map<String, dynamic> srcJson) => _$RoleInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RoleInfoToJson(this);

}
