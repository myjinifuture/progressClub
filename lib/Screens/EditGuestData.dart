import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';

class EditGuestData extends StatefulWidget {
  String name, mobile, id, memberId, city;
  EditGuestData({this.mobile, this.name, this.id, this.memberId, this.city});
  @override
  _EditGuestDataState createState() => _EditGuestDataState();
}

class _EditGuestDataState extends State<EditGuestData> {
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtCity = new TextEditingController();
  TextEditingController txtState = new TextEditingController();

  bool isLoading = false;
  String temp = "Select your state";
  String temp1 = "Select your City";

  void initState() {
    super.initState();
    txtMobile.text = widget.mobile;
    txtName.text = widget.name;
    _getStatesCities();
  }

  List stateandcities = [];
  List<String> states = [], cities = [];

  _getStatesCities() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(Session.MemberId);

        Services.getStatesCities().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != "") {
            print("statecitiesdata");
            stateandcities = data;
            for (int i = 0; i < stateandcities.length; i++) {
              if (!states.contains(stateandcities[i]["state"])) {
                states.add(stateandcities[i]["state"]);
                states.sort();
              }
            }
            print("states");
            print(states);
            // Fluttertoast.showToast(
            //     msg: "Guest Added Successfully",
            //     backgroundColor: Colors.green,
            //     gravity: ToastGravity.TOP,
            //     toastLength: Toast.LENGTH_SHORT);
            // Navigator.pushReplacementNamed(context, "/EventGuest");
          } else {
            //showMsg(data.Message);
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
    // }
    // else {
    //   Fluttertoast.showToast(
    //       msg: "Please Try Again",
    //       backgroundColor: Colors.redAccent,
    //       textColor: Colors.white,
    //       gravity: ToastGravity.BOTTOM,
    //       toastLength: Toast.LENGTH_SHORT);
    // }
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
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateGuest() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(Session.MemberId);
        print('${txtMobile.text}');
        print('${txtName.text}');
        print('${memberId}');
        print('${temp}');
        print('${temp1}');
        print(widget.id);
        Services.UpdateGuestData(
                txtMobile.text,
                txtName.text,
                widget.id,
                memberId,
                temp,
                temp1 == "Select your City" ? widget.city : temp1)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != "") {
            Fluttertoast.showToast(
                msg: "Data Updated Successfully",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pushNamedAndRemoveUntil(
                context, '/EventGuest', (route) => false);
          } else {
            //showMsg(data.Message);
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
    // }
    // else {
    //   Fluttertoast.showToast(
    //       msg: "Please Try Again",
    //       backgroundColor: Colors.redAccent,
    //       textColor: Colors.white,
    //       gravity: ToastGravity.BOTTOM,
    //       toastLength: Toast.LENGTH_SHORT);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Guest Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 6),
              child: TextFormField(
                controller: txtName,
                scrollPadding: EdgeInsets.all(0),
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    prefixIcon: Icon(
                      Icons.person,
                      //color: cnst.appPrimaryMaterialColor,
                    ),
                    hintText: widget.name),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: txtMobile,
                scrollPadding: EdgeInsets.all(0),
                maxLength: 10,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    prefixIcon: Icon(
                      Icons.call,
                    ),
                    counterText: "",
                    hintText: widget.mobile),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              child: InputDecorator(
                decoration: new InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: new Text(temp),

                    onChanged: (val) {
                      print(val);
                      cities = [];
                      for (int i = 0; i < stateandcities.length; i++) {
                        if (stateandcities[i]["state"] == val.toString()) {
                          cities.add(stateandcities[i]["name"]);
                          cities.sort();
                        }
                      }
                      print("cities");
                      print(cities);
                      setState(() {
                        temp = val;
                      });
                    },
                    //value: temp,
                    items: states.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: new TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              width: (MediaQuery.of(context).size.width - 40),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: InputDecorator(
                decoration: new InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //labelText: "",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    //isDense: true,
                    hint: new Text(temp1),
                    // value: _memberClass,
                    onChanged: (val) {
                      setState(() {
                        temp1 = val;
                      });
                    },
                    //value: temp1,
                    items: cities.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: new TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              width: (MediaQuery.of(context).size.width - 40),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              margin: EdgeInsets.only(top: 10),
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: cnst.appPrimaryMaterialColor,
                minWidth: MediaQuery.of(context).size.width - 20,
                onPressed: () {
                  updateGuest();
                },
                child: Text(
                  "Update",
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
    );
  }
}
