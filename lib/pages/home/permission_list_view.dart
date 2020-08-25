import 'package:bayue_lock/common/constant.dart';
import 'package:bayue_lock/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bayue_lock/route/ba_yue_router.dart';
import 'package:bayue_lock/route/routes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:bayue_lock/widgets/indicator_factory.dart';
import 'package:bayue_lock/pages/home/permission_item_view.dart';

import 'package:bayue_lock/models/page_result.dart';
import 'package:bayue_lock/models/home_permission_apply.dart';
import 'package:bayue_lock/widgets/load_state_layout_widget.dart';

class PermissionListView extends StatefulWidget {
  PermissionListView();

  @override
  _PermissionListViewState createState() => _PermissionListViewState();
}

class _PermissionListViewState extends State<PermissionListView>
    with AutomaticKeepAliveClientMixin {
  //页面加载状态，默认为加载中
  LoadState _layoutState = LoadState.State_Loading;

  RefreshController _refreshController;

  PageResult pageResult;
  List<HomePermissionApply> applyList = [];

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    loadData();
  }


  @override
  bool get wantKeepAlive => false;

  SmartRefresher _buildRefreshListView() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: true,
      header: buildDefaultHeader(),
      footer: buildDefaultFooter(),
      onRefresh: () {
        loadData(loadMore: false);
      },
      onLoading: () {
        loadData(loadMore: true);
      },
      child: ListView.builder(
        itemCount: applyList.length,
        itemBuilder: (context, index) {
          return PermissionItemView(
            permissionApply: applyList[index],
            onPressed: () {
              int id = applyList[index].key;
              BaYueRouter.push(
                  context, Routes.permissionApplyDetailPage, {'applyId': id});
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.white,
      child: LoadStateLayout(
        state: _layoutState,
        errorRetry: () {
          setState(() {
            _layoutState = LoadState.State_Loading;
          });
          this.loadData();
        },
        successWidget: _buildRefreshListView(),
      ),
    );
  }

  void loadData({bool loadMore = false}) {
    int page = (pageResult == null || loadMore == false)
        ? 1
        : pageResult.currentPage + 1;
    NetworkUtils.requestHomeLockApply(page).then((res) {
      if (res.status == ResponseStatus.SUCCESS) {
        pageResult = PageResult.resultTransform(res,currentPage: page);
        if (!this.mounted) {
          return;
        }
        if (loadMore) {
          if (pageResult.items.length > 0) {
            var tempList = pageResult.items
                .map((m) => HomePermissionApply.fromJson(m))
                .toList();
            applyList.addAll(tempList);
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
          setState(() {});
        } else {
          if (pageResult.items.length == 0) {
            setState(() {
              _layoutState = LoadState.State_Empty;
            });
          } else {
            applyList = pageResult.items
                .map((m) => HomePermissionApply.fromJson(m))
                .toList();
            _refreshController.refreshCompleted();
            setState(() {
              _layoutState = LoadState.State_Success;
            });
          }
        }
      } else {
        //请求失败
        if (loadMore) {
          _refreshController.loadComplete();
          setState(() {});
        } else {
          _refreshController.refreshFailed();
          setState(() {
            _layoutState = loadStateByErrorCode(res.status);
          });
        }
      }
    });
  }
}
