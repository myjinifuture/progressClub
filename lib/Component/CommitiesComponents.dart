import'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MemberDirectoryComponent.dart';

class CommitiesComponents extends StatefulWidget {
  var commities;

  CommitiesComponents(this.commities);

  @override
  _CommitiesComponentsState createState() => _CommitiesComponentsState();
}

class _CommitiesComponentsState extends State<CommitiesComponents> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        //margin: EdgeInsets.symmetric(vertical: 5),
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.commities["Title"].toString(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700])),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cnst.appPrimaryMaterialColor),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      '${widget.commities["Membes"].length.toString()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ),
              )
            ],
          ),
          children: <Widget>[
            Column(
              children: _buildExpandableContent(
                  widget.commities["Membes"].length > 0
                      ? widget.commities["Membes"]
                      : ""),
            ),
          ],
        ),
      ),
    );
  }

  _buildExpandableContent(var list) {
    List<Widget> columnContent = [];
    for (int i = 0; i < list.length; i++) {
      columnContent.add(GestureDetector(
        onTap: () {
          print('${list[i]["MemberName"]}');

          saveAndNavigator(list[i]["Id"].toString(),
              list[i]["Type"].toString().toLowerCase());
          //Navigator.pushNamed(context, '/CommitieScreen');
        },
        child: new ListTile(
            title: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipOval(
                  child: list[i]["Image"].toString() != "null" &&
                          list[i]["Image"].toString() != ""
                      ? FadeInImage.assetNetwork(
                          placeholder: 'images/icon_user.png',
                          image: list[i]["Image"].toString().contains("http")
                              ? list[i]["Image"].toString()
                              : "http://pmc.studyfield.com/" + list[i]["Image"],
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
                        "${list[i]["MemberName"]}",
                        style: new TextStyle(
                            color: cnst.appPrimaryMaterialColor, fontSize: 18),
                      ),
                      Text('${list[i]["CompanyName"]}'),
                    ],
                  ),
                )),
                GestureDetector(
                  onTap: () {

                  },
                  child: Image.asset(
                    'images/whatsapp.png',
                    height: 40,
                    width: 40,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(Icons.call,
                        size: 25, color: cnst.appPrimaryMaterialColor),
                  ),
                ),

              ],
            ),
            Divider(
              color: Colors.grey[500],
            )
          ],
        )),
      ));
    }
    if (list.length == 0 && list == null) {
      columnContent.add(new ListTile(
        title: new Text(
          "No Data Found",
          style: new TextStyle(fontSize: 18.0),
        ),
        //leading: new Icon(),
      ));
    }
    return columnContent;
  }
  saveAndNavigator(String memberId, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.memId, memberId);
    if(type == "guest") {
      Navigator.pushNamed(context, '/GuestDetails');
    } else {
      Navigator.pushNamed(context, '/MemberDetails');
    }
  }
}
