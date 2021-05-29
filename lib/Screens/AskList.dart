import 'dart:io';

import 'package:flutter/material.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';

//components dart file
import 'package:progressclubsurat_new/Component/AskComponents.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/MyAskComponents.dart';
import 'package:progressclubsurat_new/Screens/AllAsks.dart';
import 'package:progressclubsurat_new/Screens/MyAskScreen.dart';
import 'package:progressclubsurat_new/Screens/MyAsks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AskList extends StatefulWidget {
  @override
  _AskListState createState() => _AskListState();
}

class _AskListState extends State<AskList> with TickerProviderStateMixin {
  //loading var
  bool isLoading = false;
  List list = new List();
  List myasklist = [];
  String MemberId;
  String Id;
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: cnst.appPrimaryMaterialColor,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          'Ask',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),

        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,labelStyle: TextStyle(fontSize: 16),
          tabs: [
            new Tab(
              text: "General Asks",
            ),
            new Tab(
              text: "My Asks",
            ),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
         AllAsks(),
          MyAsks()
        ],
        controller: _tabController,
      ),
      floatingActionButton: FloatingActionButton(
        child:  IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/MyAskScreen');
           // Navigator.pushNamed(context, "/MyAskScreen");
          },
          icon: Icon(
            Icons.add_circle_outline,
            size: 32,
          ),
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
