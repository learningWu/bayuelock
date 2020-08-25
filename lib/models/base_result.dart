import 'package:json_annotation/json_annotation.dart';
import 'package:bayue_lock/common/constant.dart';
part 'base_result.g.dart';

@JsonSerializable()
class BaseResult {
  var data;
  int status;
  String message;
  Map<String,dynamic> meta;
  Map<String,dynamic> errors;

  BaseResult(this.data, this.status, this.message, this.errors);


  factory BaseResult.fromJson(Map<String,dynamic> json)  => _$BaseResultFromJson(json);
  Map<String,dynamic>  toJson()  => _$BaseResultToJson(this);

  static resultTransform(Map<String,dynamic> json)
  {
    Map<String,dynamic> result = new Map();
    result['data'] = json.containsKey('data') ? json['data'] : null;
    result['status'] = json.containsKey('status') ? json['status'] : ResponseStatus.SUCCESS;
    result['message'] = json.containsKey('message') ? json['message'] : null;
    result['meta'] = json.containsKey('meta') ? json['meta'] : null;

    return BaseResult.fromJson(result);
  }

  static toErrorMsg(Map<String,dynamic> errors)
  {
    String msg = "";
    errors.forEach((String key,dynamic value){
      msg += value.toString()+"\n";
    });
    return msg;
  }

}