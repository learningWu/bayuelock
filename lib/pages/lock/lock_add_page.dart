import 'package:bayue_lock/models/base_result.dart';
import 'package:bayue_lock/models/role_info.dart';
import 'package:bayue_lock/route/ba_yue_router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:bayue_lock/utils/network.dart';
import 'package:bayue_lock/widgets/load_state_layout_widget.dart';
import 'package:bayue_lock/common/constant.dart';
import 'package:multiple_select/multi_drop_down.dart';
import 'package:multiple_select/multiple_select.dart';
import 'package:oktoast/oktoast.dart';
import 'package:bayue_lock/route/routes.dart';


class LockAddPage extends StatefulWidget {
  LockAddPage({Key key, this.lockId, this.password}) : super(key: key);
  String   lockId;
  String   password;

  @override
  _LockAddPageState createState() => _LockAddPageState();
}

class _LockAddPageState extends State<LockAddPage> {

  List<MultipleSelectItem> elements;


  String  lockId;  //智能锁Id
  String  password;  //锁密码
  String  _location = "";  //安装位置
  String  _remark = "";    //备注信息
  List    _roles = new List(); //角色Id

  //页面加载状态，默认为加载中
  LoadState _layoutState = LoadState.State_Loading;

  void initState() {
    lockId = this.widget.lockId;
    password = this.widget.password;
    super.initState();
    loadData();
  }

  Widget _buldLocationEdit() {
    var node = FocusNode();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: TextEditingController(text: _location),
        onChanged: (value) {
          _location = value;
        },
        decoration: InputDecoration(
          hintText: '请输锁安装位置',
          labelText: '初始化位置',
          hintStyle:
          TextStyle(fontSize: 12.0, color: AppColors.ArrowNormalColor),
        ),
        maxLines: 1,
        maxLength: 30,
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(node);
        },
      ),
    );
  }


  Widget _buldLockRemark() {
    var node = FocusNode();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: TextEditingController(text: _remark),
        maxLines:5,
        onChanged: (value) {
          _remark = value;
        },
        decoration: InputDecoration(
          hintText: '请输安装备注',
          labelText: '备注',
          hintStyle:
          TextStyle(fontSize: 18.0, color: AppColors.ArrowNormalColor),
        ),
        keyboardType: TextInputType.text,
        autofocus: true,
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(node);
        },
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return new Padding(
      padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
      child: new RaisedButton(
        padding: new EdgeInsets.fromLTRB(130.0, 15.0, 130.0, 15.0),
        color: AppColors.PrimaryColor,
        textColor: Colors.white,
        disabledColor: AppColors.DisableTextColor,
        onPressed: (_location.isEmpty)
            ? null
            : () {
          submit();
        },
        child: new Text(
          '安 装',
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRoles(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: MultipleDropDown(
        placeholder: '请选择角色',
        disabled: false,
        values: _roles,
        elements: elements,
      ),
    );
  }

  submit() {
    NetworkUtils.requestAddLock(lockId, password, _location, _remark, _roles).then((res){
      if(res.status == ResponseStatus.SUCCESS)
      {
        showToast("安装成功", duration: Duration(milliseconds: 1500));
        Future.delayed(Duration(seconds: 2), () {
          BaYueRouter.push(
              context, Routes.lockSingleDetailPage, {'lockId': lockId},clearStack: true,
              transition: TransitionType.fadeIn);
          //BaYueRouter.push(context, Routes.lockPage , {},
          //    clearStack: true, transition: TransitionType.fadeIn);
        });
      }else{
         String msg = BaseResult.toErrorMsg(res.errors);
         showToast(msg,duration: Duration(milliseconds: 1500));
      }
    });
  }

  loadData() async {
    NetworkUtils.requestRoles()
        .then((res) {
      if (res.status == ResponseStatus.SUCCESS) {
         var items =  (res.data as List)?.map((e) => e as Map<String, dynamic>)?.toList();
         if(items.length > 0)
         {
           elements = items.map((m){
             RoleInfo roleInfo =  RoleInfo.fromJson(m);
             String name = roleInfo.name;
             return MultipleSelectItem.build(value: roleInfo.key, display: '$name', content: '$name');
           }).toList();

         }
        setState(() {
          _layoutState = LoadState.State_Success;
        });
      } else {
        setState(() {
          _layoutState = loadStateByErrorCode(res.status);
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "智能锁安装",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: LoadStateLayout(
        state: _layoutState,
        errorRetry: () {
          setState(() {
            _layoutState = LoadState.State_Loading;
          });
          this.loadData();
        },
        successWidget: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildRoles(),
              _buldLocationEdit(),
              _buldLockRemark(),
              _buildSubmitBtn()
            ],
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomBar(),
    );
  }
}
