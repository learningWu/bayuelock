import 'package:bayue_lock/pages/home/home_page.dart';
import 'package:bayue_lock/route/ba_yue_router.dart';
import 'package:bayue_lock/route/routes.dart';
import 'package:bayue_lock/utils/network.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:bayue_lock/common/constant.dart';
import 'package:bayue_lock/widgets/load_state_layout_widget.dart';
import 'package:bayue_lock/models/home_permission_apply.dart';


class PermissionApplyDetail extends StatefulWidget {
  PermissionApplyDetail({Key key, this.applyId}) : super(key: key);
  final int applyId;
  @override
  _PermissionApplyDetailState createState() => _PermissionApplyDetailState();
}

class _PermissionApplyDetailState extends State<PermissionApplyDetail> {
  //页面加载状态，默认为加载中
  LoadState _layoutState = LoadState.State_Loading;

  String _approveRemark;

  HomePermissionApply applyDetail;

  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    NetworkUtils.requestApply(this.widget.applyId)
        .then((res) {
      if (res.status == ResponseStatus.SUCCESS) {
        applyDetail = HomePermissionApply.fromJson(res.data);
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

  saveData(int status)async{
    NetworkUtils.requestSave(this.widget.applyId,_approveRemark,status).then(
        (res){
          if(res.status == ResponseStatus.SUCCESS)
          {
            showToast("操作成功", duration: Duration(milliseconds: 1500));
            Future.delayed(Duration(seconds: 2), () {
              BaYueRouter.push(context, Routes.mainPage , {},
                  clearStack: true, transition: TransitionType.fadeIn);
              // Navigator.of(context).pop();
            });
          }else{
            showToast(res.message, duration: Duration(milliseconds: 1500));

          }
        }
    );
  }


  Widget _buildTopInfoView() {
    String title = "申请人: ";
    title += applyDetail?.applyPeople ?? "";
    String createDateStr = applyDetail?.applyTime ?? "";

    return Container(
      padding: EdgeInsets.fromLTRB(8, 16, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 5),
          Text("申请时间: $createDateStr",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          Divider(color: AppColors.DividerColor),
        ],
      ),
    );
  }

  Widget _buildApplyDescTextView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          applyDetail?.remark?.trim() ?? "",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }


  Widget _buldApproveRemark() {
    var node = FocusNode();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: TextEditingController(text: _approveRemark),
        maxLines:5,
        onChanged: (value) {
          _approveRemark = value;
        },
        decoration: InputDecoration(
          hintText: '请输审批备注',
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


  Widget _buildBottomBar() {
    Widget denyView = Container(
      child: RaisedButton(
        textColor: Colors.white,
        color: Colors.red[500],
        child: Text('拒绝申请'),
        onPressed: (){
          saveData(2);
        },
      ),
    );

    Widget consentView = Container(
      child: RaisedButton(
        textColor: Colors.white,
        color: Colors.green[500],
        child: Text("同意开通"),
        onPressed: () {
          saveData(3);
        },
      ),
    );

    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical:20),
        child: Row(
          children: <Widget>[denyView, Expanded(child: SizedBox()), consentView],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "权限审批-详细信息",
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
              _buildTopInfoView(),
              _buildApplyDescTextView(),
              Divider(color: AppColors.DividerColor),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
              _buldApproveRemark(),
              _buildBottomBar()
            ],
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomBar(),
    );
  }
}
