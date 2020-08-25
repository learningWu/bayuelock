import 'package:json_annotation/json_annotation.dart';

part 'user_token.g.dart';

@JsonSerializable()

class UserToken
{
  @JsonKey(name:'token')
  String token;

  @JsonKey(name:'refreshToken')
  String refreshToken;

  @JsonKey(name:'expiresIn')
  int expiresIn;

  UserToken(this.token, this.refreshToken, this.expiresIn);

  factory UserToken.fromJson(Map<String, dynamic> srcJson) => _$UserTokenFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserTokenToJson(this);

}