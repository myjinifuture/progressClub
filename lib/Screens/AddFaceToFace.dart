import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddFaceToFace extends StatefulWidget {
  @override
  _AddFaceToFaceState createState() => _AddFaceToFaceState();
}

class _AddFaceToFaceState extends State<AddFaceToFace> {
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

  Future<void> _chooseFront(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make Choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      pickFront(ImageSource.gallery);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      pickFront(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  pickFront(source) async {
    var picture = await ImagePicker.pickImage(source: source);
    this.setState(() {
      ImageFront = picture;
    });
    Navigator.pop(context);
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

        if (ImageFront != null) {
          ImageProperties properties =
          await FlutterNativeImage.getImageProperties(ImageFront.path);

          compressedFile = await FlutterNativeImage.compressImage(
            ImageFront.path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = ImageFront.path
              .split('/')
              .last;
          filePath = compressedFile.path;
        }

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
    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacementNamed(context, "/FaceToFace");
      },
      child: Scaffold(
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
            'Add Face To Face',
            style: TextStyle(
                color: cnst.appPrimaryMaterialColor,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),

        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Chapter",
                          style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.all(Radius.circular(6))),
                          child:

                          DropdownButtonHideUnderline(
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


                      Align(
                        alignment: Alignment.centerLeft,
                        child: chapterDropDownError == null
                            ? Text(
                          "",
                          textAlign:
                          TextAlign.start,
                        )
                            : Text(
                          chapterDropDownError ?? "",
                          style: TextStyle(
                              color:
                              Colors.red[700],
                              fontSize: 12),
                          textAlign:
                          TextAlign.start,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Member",
                          style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.all(Radius.circular(6))),
                          child:  DropdownButtonHideUnderline(
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

                      Align(
                        alignment: Alignment.centerLeft,
                        child: MemberDropDownError == null
                            ? Text(
                          "",
                          textAlign:
                          TextAlign.start,
                        )
                            : Text(
                          MemberDropDownError ?? "",
                          style: TextStyle(
                              color:
                              Colors.red[700],
                              fontSize: 12),
                          textAlign:
                          TextAlign.start,
                        ),
                      ),

                      /*Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                              BorderRadius.all(Radius.circular(6))),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<MemberClass>(
                                hint: __memberCategoryClass != null
                                    ? _memberCategory != null &&
                                    _memberCategory.length > 0
                                    ? Text(" Select Member")
                                    : Text("Member Not Found")
                                    : Text("-- Member --"),
                                value: __memberCategoryClass,
                                onChanged: (val) {
                                  _onMemberSelect(val);
                                },
                                items: _memberCategory
                                    .map((MemberClass member) {
                                  return new DropdownMenuItem<MemberClass>(
                                    value: member,
                                    child: Text(
                                      member.MemberName,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              )),

                          */
                      /*
                        ),
                      ),*/

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Type",
                          style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                              value: "zoom",
                              groupValue: Type,
                              onChanged: (value) {
                                setState(() {
                                  typeSelected = true;
                                  Type = value;
                                });
                                print("Radio $value");
                              }),
                          Text(
                            "Zoom",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Radio(
                            value: "personally",
                            onChanged: (value) {
                              setState(() {
                                Type = value;
                                typeSelected = false;
                              });
                              print("Radio $value");
                            },
                            groupValue: Type,
                          ),
                          Text(
                            "Personally",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Date",
                          style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: _date == null
                                      ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      " Date",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                  )
                                      : Text("  ${setDate(_date.toString())}")),
                              GestureDetector(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: cnst.appPrimaryMaterialColor,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _dateError == null
                            ? Container()
                            : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _dateError ?? "",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Value Generated",
                          style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ),
                      TextFormField(
                        controller: txtvaluegenerated,
                        maxLines: 5,
                        decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            contentPadding:
                            EdgeInsets.only(top: 5, left: 10, bottom: 5),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide:
                                BorderSide(width: 0, color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                BorderSide(width: 0, color: Colors.black)),
                            hintText: 'Enter Value',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Upload Photo",
                          style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            _chooseFront(context);
                          },
                          child: Container(
                              child: ImageFront != null
                                  ? Image.file(
                                ImageFront,
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                              )
                                  : Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                child: DottedBorder(
                                    dashPattern: [8, 4],
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(5),
                                    padding: EdgeInsets.all(6),
                                    color: Colors.blue,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "images/addphoto.png",
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            "Add Photo",
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            /*DottedBorder(
                                            dashPattern: [8, 4],
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(5),
                                            padding: EdgeInsets.all(6),
                                            color: Colors.blue,
                                            child: Image.asset(
                                              "images/user1.png",
                                              height: 150,
                                              width: MediaQuery.of(context).size.width /
                                                  2.4,
                                              fit: BoxFit.fill,
                                            ),
                                          ),*/
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 30),
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: cnst.appPrimaryMaterialColor,
                      minWidth: MediaQuery.of(context).size.width - 20,
                      onPressed: () {
                        bool isValidate = true;
                        if (__chapterCategoryClassNew == null) {
                          isValidate = false;
                          chapterDropDownError =
                          "Please Select Chapter";
                        }
                        if (__memberCategoryClass == null) {
                          isValidate = false;
                          MemberDropDownError =
                          "Please Select Member";
                        }
                        if (__chapterCategoryClassNew == null) {
                          isValidate = false;
                          chapterDropDownError =
                          "Please Select State";
                        }
                        if (_date == null) {
                          isValidate = false;
                          _dateError = "Please Select Date";
                        }
                        if (_formkey.currentState.validate()) {
                          _addFaceToFace();
                        }

                      },
                      child: Text(
                        "ADD",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
