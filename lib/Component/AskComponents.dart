import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:url_launcher/url_launcher.dart';

class AskComponents extends StatefulWidget {
  var AskList;

  AskComponents(this.AskList);

  @override
  _AskComponentsState createState() => _AskComponentsState();
}

class _AskComponentsState extends State<AskComponents> {
  SaveShare(String val) async {
    launch(val);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemberDetails()));
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: cnst.appcolor)),
            side: BorderSide(width: 0.15, color: cnst.appPrimaryMaterialColor),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      'images/icon_ask.png',
                      height: 37,
                      width: 37,
                      fit: BoxFit.cover,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${widget.AskList["Title"]}',
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Ask From :',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${widget.AskList["Name"]}\n( ${widget.AskList["ChapterName"]} )',
                              style: TextStyle(
                                  color: cnst.appPrimaryMaterialColor,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Ask Date :',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${widget.AskList["FromDate"].substring(8, 10)}-'
                              "${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.AskList["FromDate"].substring(0, 10)).toString()))}-${widget.AskList["FromDate"].substring(0, 4)}",
                              style: TextStyle(
                                  color: cnst.appPrimaryMaterialColor,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Close Date :',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${widget.AskList["ToDate"].substring(8, 10)}-'
                              "${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.AskList["ToDate"].substring(0, 10)).toString()))}-${widget.AskList["ToDate"].substring(0, 4)}",
                              style: TextStyle(
                                  color: cnst.appPrimaryMaterialColor,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Ask :',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${widget.AskList["Description"]}',
                              style: TextStyle(
                                  color: cnst.appPrimaryMaterialColor,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Text('${widget.AskList["ChapterName"]}'),
                ),*/
                GestureDetector(
                  onTap: () {
                    String whatsAppLink = cnst.whatsAppLink;
                    String urlwithmobile = whatsAppLink.replaceAll(
                        "#mobile", "91${widget.AskList["MobileNo"]}");
                    String urlwithmsg = urlwithmobile.replaceAll("#msg", "Your Ask : ${widget.AskList["Description"]}\n");
                    SaveShare(urlwithmsg);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Container(
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.green[100]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 7, right: 7),
                              child: Text(
                                'Message on Whatsapp',
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ),
                            Image.asset(
                              'images/whatsapp.png',
                              height: 35,
                              width: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
