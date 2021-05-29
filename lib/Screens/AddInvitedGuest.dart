import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';

class AddInvitedGuest extends StatefulWidget {
  @override
  _AddInvitedGuestState createState() => _AddInvitedGuestState();
}

class _AddInvitedGuestState extends State<AddInvitedGuest> {
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtGuestMobile = new TextEditingController();
  TextEditingController txtInvitedMobile = new TextEditingController();
  TextEditingController txtPaymentMode = new TextEditingController();
  List<eventClass> _eventList = [];
  eventClass _eventClass;
  bool isLoading = true;

  @override
  void initState() {
    _getEventData();
  }

  _getEventData() async {
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

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
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
          elevation: 0,
          title: Text("Add Invited Guest"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 7),
                        child: TextFormField(
                          controller: txtGuestMobile,
                          scrollPadding: EdgeInsets.all(0),
                          maxLength: 10,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.phone_android,
                              ),
                              counterText: "",
                              hintText: "Guest Mobile No"),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 6),
                        child: TextFormField(
                          controller: txtName,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.person,
                                //color: cnst.appPrimaryMaterialColor,
                              ),
                              hintText: "Guest Name"),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 6),
                        child: TextFormField(
                          controller: txtPaymentMode,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.attach_money,
                                //color: cnst.appPrimaryMaterialColor,
                              ),
                              hintText: "Payment Mode"),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: InputDecorator(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<eventClass>(
                            hint: _eventList.length > 0
                                ? Text("Select Event",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black45))
                                : Text("No Event Found",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black45)),
                            value: _eventClass,
                            onChanged: (val) {
                              setState(() {
                                _eventClass = val;
                                print("${val.eventId},${val.eventName}");
                              });
                            },
                            style: TextStyle(
                                fontSize: 15, color: Color(0xff5946a8)),
                            items: _eventList.map((eventClass events) {
                              return DropdownMenuItem<eventClass>(
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
                      Container(
                        margin: EdgeInsets.only(top: 7, bottom: 7),
                        child: TextFormField(
                          controller: txtInvitedMobile,
                          scrollPadding: EdgeInsets.all(0),
                          maxLength: 10,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.phone_android,
                              ),
                              counterText: "",
                              hintText: "Mobile No of Invited Person"),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        margin: EdgeInsets.only(top: 15),
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color: cnst.appPrimaryMaterialColor,
                          minWidth: MediaQuery.of(context).size.width - 20,
                          onPressed: () {
                            //_addGuest();
                          },
                          child: Text(
                            "Add Guest",
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
              ));
  }
}
