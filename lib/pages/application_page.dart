import 'package:bayue_lock/pages/lock/lock_page.dart';
import 'package:bayue_lock/utils/request_user.dart';
import 'package:flutter/material.dart';
import 'package:bayue_lock/common/constant.dart' show AppColors;
import 'profile/profile_page.dart';
import 'home/home_page.dart';

class ApplicationPage extends StatefulWidget {
  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> with SingleTickerProviderStateMixin {
  int page = 0;
  String title = '智能锁权限审批';
  PageController pageController;
  GlobalKey<ScaffoldState> registKey = new GlobalKey();

  //定义底部导航项目
  final List<BottomNavigationBarItem> _bottomTabs = <BottomNavigationBarItem> [
    BottomNavigationBarItem(
      icon: Icon(Icons.tune),
      title: Text('锁权限审批'),
      backgroundColor: AppColors.PrimaryColor,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.landscape),
      title: Text('智能锁管理'),
      backgroundColor: AppColors.PrimaryColor,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      title: Text('个人中心'),
      backgroundColor: AppColors.PrimaryColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: this.page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RequestUser.refreshToken(context);

    return Scaffold(
      key: registKey,
      appBar: AppBar(
        title: Text(this.title, style: TextStyle(color: Colors.white),),
        elevation: 0.0,
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(), /// 去除滑动手势
        children: <Widget>[
          HomePage(),
          LockPage(),
          ProfilePage()
        ],
        controller: pageController,
        onPageChanged: (int index){
          onPageChanged(index);
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: _bottomTabs,
        currentIndex: page,
        fixedColor: AppColors.PrimaryColor,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          onTap(index);
        },
      ),
    );
  }

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int page) {
    setState(() {
      this.page = page;
      switch (page) {
        case 0:
          title = "锁权限审批";
          break;
        case 1:
          title = "智能锁管理";
          break;
        case 2:
          title= "个人中心";
          break;
      }
    });
  }
}