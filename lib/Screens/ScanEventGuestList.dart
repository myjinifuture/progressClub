import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanEventGuest extends StatefulWidget {
  @override
  _ScanEventGuestState createState() => _ScanEventGuestState();
}

class _ScanEventGuestState extends State<ScanEventGuest> {
  List<eventClass> _eventList = [];
  eventClass _eventClass;

  bool isLoading = false, isSearching = false;
  List _allVisitorList = new List();
  List _searchList = new List();
  List _eventData=[];
  String Invitemsg = "";
      int Count=0;
  TextEditingController searchText = new TextEditingController();

  //ProgressDialog pr;

  @override
  void initState() {
    getEventData();
    getVisitorData("0");
    /*pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));*/
  }

  getEventData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetGeneralEvents();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              _eventList = data;
            });
          } else {
            setState(() {
              isLoading = false;
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
      showMsg("No Internet Connection.");
    }
  }

  getEventMessage(eventId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //pr.show();
        Future res = Services.ShrinkURL(eventId);
        res.then((data) async {
          if (data != null && data.length > 0) {
           // pr.hide();

            var shortLink = data;
            var msg = "";
            for (int i = 0; i < _eventList.length; i++) {
              if (_eventList[i].eventId == eventId)
                msg = _eventList[i].InviteMsg;
            }

            if (msg.length > 0 && msg.contains('#link#')) {
              msg = msg.replaceAll('#link#', shortLink);
            }

            setState(() {
              Invitemsg = msg;
            });
          } else {
          //  pr.hide();
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
         // pr.hide();
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getVisitorData(eventId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
       // pr.show();
        // Future res = Services.GetEventVisitor(eventId);
        Services.GetEventVisitor(eventId).then((data) async {
          if (data != null && data.length > 0) {
         //   pr.hide();
            setState(() {
              _allVisitorList = data;
            });
          } else {
          //  pr.hide();
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
         // pr.hide();
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _addVisitorToEvent(index) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        var data = {
          'Id': 0,
          'VisitorId': _allVisitorList[index]["Id"],
          'EventId': _eventClass.eventId,
        };

        Services.AddVisitorToEvent(data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data == "1") {
            setState(() {
              _allVisitorList[index]["status"] = "Invited";
            });
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  MemberCount(String eventId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        Services.EventCount(eventId).then(
                (responselist) async {
              if (responselist.length > 0) {
                setState(() {
                  _eventData=responselist;
                });
                int count=0;
                for(int i=0;i<_eventData.length;i++){

                    count = count+_eventData[i]["Count"];
                }
                setState(() {
                  Count=count;
                });
              } else {
                setState(() {
                  _eventData=responselist;
                });
                Fluttertoast.showToast(msg: "Data Not Found!");
              }
            }, onError: (e) {
          print("error on call -> ${e.message}");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  }

  _openWhatsapp(mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91${mobile}");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", Invitemsg);

    if (Platform.isIOS) {
      launch(urlwithmsg, forceSafariVC: false);
    } else {
      launch(urlwithmsg);
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

  _deleteGuest(String Id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.DeleteGuest(Id).then((data) async {
          if (data.Data == "1") {
            setState(() {
              isLoading = false;
            });
            getVisitorData(_eventClass.eventId);
          } else {
            isLoading = false;
            showHHMsg("Complaint Is Not Deleted", "");
          }
        }, onError: (e) {
          isLoading = false;
          showHHMsg("$e", "");
          isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  void _showConfirmDialog(String Id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Progress Club"),
          content: new Text("Are You Sure You Want To Delete this Guest ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteGuest(Id);
              },
            ),
          ],
        );
      },
    );
  }

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
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
          'Guest Invite',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/AddGuest");
            },
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                        border: Border.all(color: cnst.appPrimaryMaterialColor),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 3, right: 3, top: 2, bottom: 2),
                      child: Text(
                        "Add\nGuest",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, color: cnst.appPrimaryMaterialColor),
                      ),
                    ))),
          ),
        ],
      ),
      body: isLoading
          ? LoadinComponent()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: InputDecorator(
                      decoration: new InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                          )),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<eventClass>(
                        hint: _eventList.length > 0
                            ? Text("Select Event")
                            : Text("No Event Found"),
                        value: _eventClass,
                        onChanged: (val) {
                          setState(() {
                            _eventClass = val;
                            isSearching = false;
                            searchText.text = "";
                            print("Event Id"+val.eventId);
                            getEventMessage(val.eventId);
                            getVisitorData(val.eventId);
                            MemberCount(val.eventId);
                          });
                        },
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff5946a8)),
                        items: _eventList.map((eventClass events) {
                          return new DropdownMenuItem<eventClass>(
                            value: events,
                            child: Text(
                              events.eventName,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      )),
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Chapter Name",style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Total",style: TextStyle(fontWeight: FontWeight.bold))

                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.separated(
                        itemCount: _eventData.length,
                        itemBuilder: (BuildContext context,int index){
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("${_eventData[index]["Chapter"]}"),
                            Text("${_eventData[index]["Count"]}",style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      );
                      },
                      separatorBuilder: (context,index){
                          return Divider();
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                ],
              ),
            ),
      bottomNavigationBar: Container(height: 55,child: Column(
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Total Count: "),
              Text("${Count}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            ],
          ),
        ],
      )),
    );
  }

  void searchOperation(String searchText) {
    _searchList.clear();
    setState(() {
      isSearching = true;
    });
    if (searchText != "") {
      for (int i = 0; i < _allVisitorList.length; i++) {
        String name = _allVisitorList[i]["Name"];
        String cmpName = _allVisitorList[i]["MobileNo"];
        String cmpcity = _allVisitorList[i]["City"];
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            cmpName.toLowerCase().contains(searchText.toLowerCase())||
            cmpcity.toLowerCase().contains(searchText.toLowerCase())) {
          _searchList.add(_allVisitorList[i]);
        }
      }
    } else
      setState(() {
        isSearching = false;
      });
    setState(() {});
  }
}
