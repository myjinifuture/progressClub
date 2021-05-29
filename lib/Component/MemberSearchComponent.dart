import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Screens/MemberDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberSearchComponent extends StatefulWidget {
  var memberList;

  //images/icon_member.jpg

  MemberSearchComponent(this.memberList);

  @override
  _MemberSearchComponentState createState() => _MemberSearchComponentState();
}

class _MemberSearchComponentState extends State<MemberSearchComponent> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        saveAndNavigator();
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
                                  ? widget.memberList["Image"].toString()
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
                            '${widget.memberList["PersonName"]}',
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 18),
                          ),
                          Text('${widget.memberList["CompanyName"]}'),
                          Text('${widget.memberList["ChapterName"]}'),
                        ],
                      ),
                    )),
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
                        launch("tel:" + widget.memberList['MobileNo']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.call,
                            size: 25, color: cnst.appPrimaryMaterialColor),
                      ),
                    ),
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
