import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/pages/ContactService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberDirectoryComponent extends StatefulWidget {
  var memberList, chapterName, UserType;

  //images/icon_member.jpg

  MemberDirectoryComponent(this.memberList, this.chapterName, this.UserType);

  @override
  _MemberDirectoryComponentState createState() =>
      _MemberDirectoryComponentState();
}

class _MemberDirectoryComponentState extends State<MemberDirectoryComponent> {
//  saveAndNavigator() async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    await prefs.setString(Session.memId,widget.memberList["Id"].toString());
//    Navigator.pushNamed(context, '/MemberDetails');
//  }
  Contact contact = Contact();

  @override
  void initState() {
    super.initState();
  }

  saveAndNavigator() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.memId, widget.memberList["Id"].toString());
    if ((widget.memberList['Type'].toString().toLowerCase() == "guest")) {
      Navigator.pushNamed(context, '/GuestDetails');
    } else {
      Navigator.pushNamed(context, '/MemberDetails');
    }
  }

  _openWhatsapp() {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll(
        "#mobile", "91${widget.memberList["MobileNo"]}");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  _addToContact() {
    var chap = widget.chapterName.toString().trim().split(" ");
    String prefix = "";
    try {
      prefix = chap[0].substring(0, 1) +
          chap[1].substring(0, 1) +
          chap[2].substring(0, 1) +
          " ";
    } catch (e) {
      prefix = "PC ";
    }
    setState(() {
      contact.givenName = prefix + widget.memberList["Name"];
      contact.phones = [
        Item(label: "mobile", value: widget.memberList["MobileNo"])
      ];
      contact.emails = [Item(label: "work", value: widget.memberList["Email"])];
      contact.company = widget.memberList["CompanyName"];
      contact.emails = [
        Item(label: "work", value: widget.memberList[""])
      ];
    });

    ContactService.addContact(contact);
    showMsg("Contact Saved Successfully...");
    /*Fluttertoast.showToast(
        msg: "Contact Saved Successfully...",
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG);*/
  }


  showMsg(String msg, {String title = 'Progress Club'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        saveAndNavigator();
        /*Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MemberDetails()));*/
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Card(
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: cnst.appcolor)),
            side: BorderSide(width: 0.50, color: cnst.appPrimaryMaterialColor),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipOval(
                      child: widget.memberList["Image"] != null &&
                              widget.memberList["Image"] != ""
                          ? FadeInImage.assetNetwork(
                              placeholder: 'images/icon_user.png',
                              image: widget.memberList["Image"]
                                      .toString()
                                      .contains("http")
                                  ? widget.memberList["Image"]
                                  : "http://pmc.studyfield.com/" +
                                      widget.memberList["Image"],
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'images/icon_user.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${widget.memberList["Name"]}',
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 18),
                          ),
                          Text('${widget.memberList["CompanyName"]}'),
                        ],
                      ),
                    )),
                    widget.UserType.toLowerCase() != "guest"
                        ? Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _openWhatsapp();
                                },
                                child: Image.asset(
                                  'images/whatsapp.png',
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  launch(
                                      "tel:" + widget.memberList['MobileNo']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.call,
                                      size: 25,
                                      color: cnst.appPrimaryMaterialColor),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _addToContact();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.person_add,
                                      size: 25,
                                      color: cnst.appPrimaryMaterialColor),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
