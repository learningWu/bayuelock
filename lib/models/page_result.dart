
import 'package:bayue_lock/models/base_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page_result.g.dart';

@JsonSerializable()
class PageResult extends Object {

  @JsonKey(name: 'currentPage')
  int currentPage;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'totalNum')
  int totalNum;

  @JsonKey(name: 'isMore')
  int isMore;

  @JsonKey(name: 'totalPage')
  int totalPage;

  @JsonKey(name: 'startIndex')
  int startIndex;

  @JsonKey(name: 'items')
  List<Map> items;

  PageResult(this.currentPage,this.pageSize,this.totalNum,this.isMore,this.totalPage,this.startIndex,this.items,);

  factory PageResult.fromJson(Map<String, dynamic> srcJson) => _$PageResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PageResultToJson(this);


  static resultTransform(BaseResult res,
      {int currentPage = 1})
  {
    Map<String, dynamic> transform = new Map();
    transform['items'] = res.data;
    Map<String, dynamic> page = res.meta['pagination'];
    transform['currentPage'] = currentPage;
    transform['totalNum'] = page['totalNum'];
    transform['totalPage'] = page['total_pages'];
    transform['startIndex'] = page['per_page'];
    return PageResult.fromJson(transform);
  }


}