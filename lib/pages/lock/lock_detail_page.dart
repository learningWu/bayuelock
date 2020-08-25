import 'package:bayue_lock/models/lock_info.dart';
import 'package:bayue_lock/route/ba_yue_router.dart';
import 'package:bayue_lock/route/routes.dart';
import 'package:bayue_lock/utils/network.dart';
import 'package:bayue_lock/widgets/load_state_layout_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:bayue_lock/common/constant.dart';


class LockDetailPage extends StatefulWidget {
  LockDetailPage({Key key, this.lockId}) : super(key: key);
  String   lockId;

  @override
  _LockDetailPageState createState() => _LockDetailPageState();
}

class _LockDetailPageState extends State<LockDetailPage> {

  LockInfo lockInfo;

  //页面加载状态，默认为加载中
  LoadState _layoutState = LoadState.State_Loading;

  void initState() {
    super.initState();
    loadData();
  }


  loadData() async {
    NetworkUtils.lockPwd(this.widget.lockId)
        .then((res) {
      if (res.status == ResponseStatus.SUCCESS) {
        lockInfo = LockInfo.fromJson(res.data);
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

  Widget _returnBtn() {
    return new Padding(
      padding: EdgeInsets.only(top: 60.0, bottom: 30.0),
      child: new RaisedButton(
        padding: new EdgeInsets.fromLTRB(130.0, 15.0, 130.0, 15.0),
        color: AppColors.PrimaryColor,
        textColor: Colors.white,
        disabledColor: AppColors.DisableTextColor,
        onPressed: (){
          BaYueRouter.push(context, Routes.mainPage , {},
                 clearStack: true, transition: TransitionType.fadeIn);
        },
        child: new Text(
          '继续安装',
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTopInfoView() {
    String title = lockInfo?.location ?? ""; //安装位置

    return Container(
      padding: EdgeInsets.fromLTRB(8, 16, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildInstallView()
  {

    String createDateStr = lockInfo?.createTime ?? ""; //创建时间
    String createPeople = lockInfo?.createName ?? ""; //安装人
    String status = lockInfo?.status ?? "";
    String updaterPeople = lockInfo?.updatedName ?? ""; //安装人



    return Container(
        padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
        child: Column(
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("安装人:$createPeople",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Expanded(child: SizedBox()),
                    Text("修改人:$updaterPeople",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Divider(color: AppColors.DividerColor),
                  ]
              ),
              SizedBox(height: 5,),
              Row(
                  children:<Widget>[
                    Text("安装时间: $createDateStr",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Expanded(child: SizedBox()),
                    Text("锁状态:$status",
                        style: TextStyle(
                            color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                  ]
              ),
            ],
          )

    );
  }


  Widget _buildLockDescTextView() {
    return Row(
        children: <Widget>[
          Text(
            lockInfo?.remark?.trim() ?? "",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16),
          )
        ]);
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "锁详细信息",
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
                _buildInstallView(),
                Divider(color: AppColors.DividerColor),
                _buildLockDescTextView(),
                _returnBtn(),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(),
      );
    }
}
