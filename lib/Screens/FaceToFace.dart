import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/FaceToFaceComponent.dart';
import 'package:progressclubsurat_new/Screens/AddFaceToFace.dart';
import 'package:progressclubsurat_new/Screens/GetFaceToFace.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceToFace extends StatefulWidget {
  @override
  _FaceToFaceState createState() => _FaceToFaceState();
}

class _FaceToFaceState extends State<FaceToFace>with TickerProviderStateMixin {
  TabController _tabController;

  /* String dropdownValue = 'Progress Club 1';
  String dropdownmember = 'abc';*/
  bool isLoading = false;
  List list = new List();
  ProgressDialog pr;

  String _member = "Select";

  //List memberlist = new List();
  bool categoryLoading = false;
  String memberId = "",
      chapterId = "",
      chapterName = "Select Chapter Name",
      memberName = "";

  String _chapterDropdownError, _memberDropdownError;

  //String _category;
  DateTime _date;
  String _dateError;
  File ImageFront;
  bool typeSelected = false;
  String Type = "";

  List<ChapterClass> _chapterCategory = [];
  ChapterClass __chapterCategoryClassNew;

  List<MemberClass> _memberCategory = [];
  MemberClass __memberCategoryClass;


  TextEditingController txtvaluegenerated = new TextEditingController();



  @override
  void initState() {
    _getlist();
    super.initState();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            //backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }



  _getlist() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        Future res = Services.GetFaceToFace(preferences.getString(cnst.Session.MemberId));
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              list = data;
              isLoading = false;
            });
          } else {
            setState(() {
              list = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on GetAd Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Face To Face',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),

      ),

      body: Column(
        children: <Widget>[
          /* Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: 4,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                        child: FaceToFaceComponent());
                  }),
            ),
          )*/

          isLoading
              ? Center(child: CircularProgressIndicator())
              : list.length > 0
              ? Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: list.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                        child: FaceToFaceComponent(list[index],() {
                          setState(() {
                            list.removeAt(index);
                          });
                        }));
                  }),
            ),
          )
              : Center(
              child: Text(
                "No Data Found",
                style: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w500),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushReplacementNamed(context, '/AddFaceToFace');
        },
        child:  Icon(
          Icons.add_circle_outline,
          size: 32,
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
