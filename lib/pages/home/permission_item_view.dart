import 'package:flutter/material.dart';
import 'package:bayue_lock/common/constant.dart'
    show AppSize, AppColors;
import 'package:bayue_lock/models/home_permission_apply.dart';

class PermissionItemView extends StatelessWidget {
  const PermissionItemView({Key key, this.permissionApply, this.onPressed})
      : assert(permissionApply != null),
        super(key: key);

  final HomePermissionApply permissionApply;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: this.onPressed,
      child: Container(
          height: 100.0,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            width: AppSize.DividerWidth,
            color: AppColors.DividerColor,
          ))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        permissionApply.remark,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 15.0, color: AppColors.DarkTextColor),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(permissionApply.applyTime,
                              style: TextStyle(
                                  color: AppColors.LightTextColor,
                                  fontSize: 12.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('申请人:',
                                  style: TextStyle(
                                      color: AppColors.LightTextColor,
                                      fontSize: 12.0)
                              ),
                              Text(permissionApply.applyPeople,
                                  style: TextStyle(
                                      color: AppColors.LightTextColor,
                                      fontSize: 12.0)
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
