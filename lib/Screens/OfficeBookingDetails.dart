import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';
import 'package:progressclubsurat_new/Component/OfficeBookingDetailComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfficeBookingDetails extends StatefulWidget {
  final String date, memberId;

  const OfficeBookingDetails({Key key, this.date, this.memberId})
      : super(key: key);

  @override
  _OfficeBookingDetailsState createState() => _OfficeBookingDetailsState();
}

class _OfficeBookingDetailsState extends State<OfficeBookingDetails> {
  bool isLoading = false;
  List listMeeting = new List();

  String _Fromtime = "Select From Time";
  String _Totime = "Select To Time";
  String method = "COD";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.date);
    getOfficeBookingFromServer();
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

  getOfficeBookingFromServer() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
          //listMeeting = new List();
        });

        Future res = Services.GetOfficeBookingByDate(widget.date);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              listMeeting = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          showMsg("Try Again.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      setState(() {
        isLoading = false;
      });
    }
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
          'Office Booking Details',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height / 1.25,
                      width: MediaQuery.of(context).size.width,
                      child: LoadinComponent(),
                    )
                  : listMeeting.length > 0
                      ? Container(
                          height: MediaQuery.of(context).size.height / 1.25,
                          margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            itemCount: listMeeting.length,
                            itemBuilder: (BuildContext context, int index) {
                              return OfficeBookingDetailComponent(
                                  listMeeting[index],
                                  widget.memberId,
                                  "Meeting");
                            },
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height / 1.25,
                          width: MediaQuery.of(context).size.width,
                          child: NoDataComponent(),
                        ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 0),
                  height: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0.0)),
                    color: cnst.appPrimaryMaterialColor,
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      _settingModalBottomSheet(context);
                    },
                    child: Text(
                      "Request Booking",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => BottomSheet(
        listMeeting,
        widget.date,
        (action) {
          /*setState(() {
            method = action;
          });*/
          if (action == "update") {
            getOfficeBookingFromServer();
          }
        },
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  List bookingList;
  String date;
  Function onchange;

  BottomSheet(this.bookingList, this.date, this.onchange);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  String paymentMethod = "";
  String _Fromtime = "From Time";
  String _Totime = "To Time";
  TextEditingController edtDesc = new TextEditingController();
  bool isChecked = false;
  DateTime FromDate, ToDate;

  ProgressDialog pr;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));

    // TODO: implement initState
    super.initState();
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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

  //send More Info to server
  sendRequestBookingFn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(Session.MemberId);
        var data = {
          'Id': "0",
          'MemberId': memberId,
          'FromTime': _Fromtime.toString(),
          'ToTime': _Totime.toString(),
          'Purpose': edtDesc.text.toString().trim(),
          'Date': widget.date,
        };
        Services.sendRequestBooking(data).then((data) async {
          pr.hide();
          if (data.Data != "0" && data != "") {
            Navigator.pop(context);
            widget.onchange("update");
            showMsg("Request Booking Successfully");
          } else {
            pr.hide();
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        pr.hide();
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  String path;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/teste.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost() async {
    final response = await http
        .get('http://pmc.studyfield.com/Resources/Rules_and_regulations.pdf');
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  loadPdf() async {
    writeCounter(await fetchPost());
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
            top: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: new Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Text(
                    "Request Booking",
                    style: TextStyle(
                        color: cnst.appPrimaryMaterialColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      //color: Colors.black,
                      width: (MediaQuery.of(context).size.width / 1.8) - 30,
                      child: Row(
                        children: <Widget>[
                          Text('From : '),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                DatePicker.showTimePicker(context,
                                    theme: DatePickerTheme(
                                      containerHeight: 250.0,
                                    ),
                                    showTitleActions: true, onConfirm: (time) {
                                  //print('confirm $time');
                                  setState(() {
                                    FromDate = DateFormat("HH:mm").parse(
                                        '${time.hour}:${time.minute}'); // think this will work better for you
                                    _Fromtime = DateFormat("hh:mm a")
                                        .format(FromDate)
                                        .toString();
                                    // print(
                                    //  DateFormat("hh:mm a").format(FromDate));
                                  });
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                                setState(() {});
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                    child: Text(
                                  "${_Fromtime}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: _Fromtime == "From Time"
                                          ? Colors.grey
                                          : Colors.black),
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      //color: Colors.yellow,
                      width: (MediaQuery.of(context).size.width / 1.8) - 30,
                      child: Row(
                        children: <Widget>[
                          Text('To : '),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (_Fromtime != "From Time") {
                                  DatePicker.showTimePicker(context,
                                      theme: DatePickerTheme(
                                        containerHeight: 210.0,
                                      ),
                                      showTitleActions: true,
                                      onConfirm: (time) {
                                    // print('confirm $time');
                                    ToDate = DateFormat("HH:mm").parse(
                                        '${time.hour}:${time.minute}'); // think this will work better for you
                                    if (FromDate.isBefore(ToDate)) {
                                      setState(() {
                                        _Totime = DateFormat("hh:mm a")
                                            .format(ToDate)
                                            .toString();
                                        //  print(DateFormat("hh:mm a")
                                        //   .format(ToDate));
                                      });
                                    } else {
                                      setState(() {
                                        _Totime = "To Time";
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Please Select Valid Time",
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          gravity: ToastGravity.TOP,
                                          toastLength: Toast.LENGTH_SHORT);
                                    }
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                  setState(() {});
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "First Select From Time",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      gravity: ToastGravity.TOP,
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(
                                    "${_Totime}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: _Totime == "To Time"
                                            ? Colors.grey
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 10, bottom: 10),
                child: Container(
                  child: TextFormField(
                    controller: edtDesc,
                    scrollPadding: EdgeInsets.all(0),
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        hintText: "Purpose",
                        hintStyle: TextStyle(fontSize: 13)),
                    maxLines: 4,
                    minLines: 2,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: isChecked,
                    activeColor: cnst.appPrimaryMaterialColor,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      await loadPdf();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OfficeBookingRules(path)));
                    },
                    child: Text("Accept Rules and Regulations",
                        style: TextStyle(fontSize: 15, color: Colors.blue)),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                margin: EdgeInsets.only(bottom: 10),
                child: MaterialButton(
                  color: cnst.appPrimaryMaterialColor,
                  onPressed: () {
                    if (_Fromtime != "From Time") {
                      if (_Totime != "To Time") {
                        if (edtDesc.text != "") {
                          if (isChecked) {
                            sendRequestBookingFn();
                          } else {
                            Fluttertoast.showToast(
                                msg: "First read Rules and Regulation.",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_SHORT);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Enter Purpose.",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              gravity: ToastGravity.BOTTOM,
                              toastLength: Toast.LENGTH_SHORT);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Select To Time",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_SHORT);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Select From Time",
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT);
                    }
                  },
                  child: Text(
                    "Submit",
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
    );
  }
}

class OfficeBookingRules extends StatefulWidget {
  String path;

  OfficeBookingRules(this.path);

  @override
  _OfficeBookingRulesState createState() => _OfficeBookingRulesState();
}

class _OfficeBookingRulesState extends State<OfficeBookingRules> {
  @override
  Widget build(BuildContext context) {
    print(widget.path);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: cnst.appPrimaryMaterialColor),
        ),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        // child: PDFView(
        //   filePath: widget.path,
        // ),
      )),
    );
  }
}
