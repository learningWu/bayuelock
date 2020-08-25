import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';


@JsonSerializable()

class UserInfo
{
  @JsonKey(name: 'userId')
  int userId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'describe')
  String describe;

  UserInfo(this.userId, this.name, this.avatar ,this.describe);

  factory UserInfo.fromJson(Map<String, dynamic> srcJson) => _$UserInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

}