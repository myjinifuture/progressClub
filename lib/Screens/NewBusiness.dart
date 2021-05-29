import 'dart:io';
import '../Common/Constants.dart' as cnst;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
class NewBusiness extends StatefulWidget {
  @override
  _NewBusinessState createState() => _NewBusinessState();
}

class _NewBusinessState extends State<NewBusiness> {
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);

  bool isLoading = false;
  List list = new List();
  ProgressDialog pr;
  String memberId = "",
      chapterId = "",
      chapterName = "Select Chapter Name",
      memberName = "";
  DateTime _date;
  String _dateError;
  File ImageFront;
  bool typeSelected = false;
  String Type = "";

  List<ChapterClass> _chapterCategory = [];
  ChapterClass __chapterCategoryClassNew;

  List<MemberClass> _memberCategory = [];
  MemberClass __memberCategoryClass;

  String chapterDropDownError,MemberDropDownError;


  TextEditingController txtvaluegenerated = new TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    isLoading = true;
    // TODO: implement initState
    super.initState();
    getProffesionFromServer();
  }


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1960),
        lastDate: new DateTime(2021));

    if (picked != null && picked != _date && picked != "null") {
      print("Date Selected -->>${_date.toString()}");
      setState(() {
        _date = picked;
        _dateError = null;
      });
    }
  }

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" && date != null && date != "null") {
      tempDate = date.toString().split("-");

      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = "${tempDate[2].toString().substring(0, 2)}-"
          "${tempDate[1].toString().substring(0, 2)}-${tempDate[0].toString()}"
          .toString();
    }
    return final_date;
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



  getDirectoryFromServer(String chapterid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          //cityLoading = true;
        });
        Future res = Services.GetMemberByChapter(chapterid);
        res.then((data) async {
          setState(() {
            // cityLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              _memberCategory = data;
            });
            print("member123=>"+_memberCategory.toString());
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            //cityLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        //cityLoading = false;
      });
    }
  }

  _addFaceToFace() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        String filename = "";
        String filePath = "";
        File compressedFile;


        SharedPreferences preferences = await SharedPreferences.getInstance();
        FormData data = FormData.fromMap({
          "Id": 0,
          "ChapterId": __chapterCategoryClassNew.ChapterId,
          "MemberId": __memberCategoryClass.MemberId,
          "Type": Type,
          "MeetingDate": _date.toString(),
          "ValueTaken": txtvaluegenerated.text,
          "Photo": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
              filename: filename.toString())
              : null,
          "LoginMemberId" : preferences.getString(cnst.Session.MemberId)
        });

        Services.AddFaceToFace(data).then((data) async {
          setState(() {
            isLoading = false;
          });

          if (data.Data != "0" && data.IsSuccess == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(cnst.Session.FaceToFaceImage, "${data.Data}");

            Fluttertoast.showToast(
                msg: "Added Successfully !",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);

            Navigator.pushReplacementNamed(context, "/FaceToFace");

            /*  Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);*/
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });

          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }


  getData() {
    if (chapterId == "" || chapterId == "null" || chapterId == null) {
      setState(() {
        _chapterCategory.insert(0, __chapterCategoryClassNew);
      });
    }
    for (int i = 0; i < _chapterCategory.length; i++) {
      if (chapterId.toString() == _chapterCategory[i].ChapterId.toString()) {
        chapterName = _chapterCategory[i].ChapterName.toString();
      }
    }
    /*for (int i = 0; i < list.length; i++) {
      if (memberId.toString() == list[i].MemberId.toString()) {
        memberName = list[i].MemberName.toString();
      }
    }*/

    /*setState(() {

    });*/
  }



  getProffesionFromServer() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetChapterData();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              __chapterCategoryClassNew =
              new ChapterClass(ChapterId: 0, ChapterName: "All");
              _chapterCategory = data;
              getData();
            });
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("New Business"),
              ],
               ),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text("Chapter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(":",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 190,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<
                                ChapterClass>(
                              isExpanded: true,
                              hint: _chapterCategory
                                  .length >
                                  0
                                  ? Text(
                                'Select Chapter',
                                style: TextStyle(
                                    fontSize:
                                    12),
                              )
                                  : Text(
                                "Chapter Not Found",
                                style: TextStyle(
                                    fontSize:
                                    12),
                              ),
                              value: __chapterCategoryClassNew,
                              onChanged: (newValue) {
                                setState(() {
                                  __chapterCategoryClassNew =
                                      newValue;



                                  __memberCategoryClass=null;
                                  _memberCategory=[];

                                });
                                getDirectoryFromServer(newValue.ChapterId.toString());
                              },
                              items: _chapterCategory
                                  .map((ChapterClass
                              value) {
                                return DropdownMenuItem<
                                    ChapterClass>(
                                  value: value,
                                  child: Text(
                                      value.ChapterName),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text("Member",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(":",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 190,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<
                                  MemberClass>(
                                isExpanded: true,
                                hint: _memberCategory
                                    .length >
                                    0
                                    ? Text(
                                  ' Select Member',
                                  style: TextStyle(
                                      fontSize: 12),
                                )
                                    : Text(
                                  " Member Not Found",
                                  style: TextStyle(
                                      fontSize: 12),
                                ),
                                value: __memberCategoryClass,
                                onChanged: (newValue) {
                                  setState(() {
                                    __memberCategoryClass = newValue;

                                  });
                                },
                                items: _memberCategory.map(
                                        (MemberClass value) {
                                      return DropdownMenuItem<
                                          MemberClass>(
                                        value: value,
                                        child: Text(value.MemberName),
                                      );
                                    }).toList(),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text("Amount",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(":",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 190,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Enter Amount",
                              labelStyle: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text("Date",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(":",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 45,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 190,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.black)),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("$formatted",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 55,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.purple,
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),

                ),
                SizedBox(
                  width: 60,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.purple,
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );

  }
}
