import 'package:flutter/material.dart';
import 'permission_list_view.dart';

class HomePage extends StatefulWidget {
  @override
  _ClassifyPageState createState() => _ClassifyPageState();
}

class _ClassifyPageState extends State<HomePage>
{

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

 // @override
 // bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return PermissionListView();
  }
}