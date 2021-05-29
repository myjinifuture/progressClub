import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:url_launcher/url_launcher.dart';

class SaleScreen extends StatefulWidget {
  List searchpropertylistdata;
  SaleScreen({this.searchpropertylistdata});
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {

  int _pos = 0;
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _pos = widget.searchpropertylistdata[0]["Data"].length !=0 ?(_pos + 1) % widget.searchpropertylistdata[0]["Data"].length : 0;
      });
    });
    super.initState();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text(
            'Sale',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: GestureDetector(
            onTap: () {
              widget.searchpropertylistdata.clear();
              print("search after clear");
              print(widget.searchpropertylistdata);
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  icon: Icon(
                    Icons.share,
                  ),
                  onPressed: () {}),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  icon: Icon(
                    Icons.local_library,
                  ),
                  onPressed: () {}),
            ),
          ],
        ),
        body: Container(
          color: Colors.grey[350],
          child: Column(
            children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 50,
//                 child: Stack(
//                   children: <Widget>[
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.white,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Center(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 40.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(0),
//                                     color: Colors.grey,
// //                                    border: Border.all(color: Colors.grey[400]),
//                                   ),
//                                   width: 70,
//                                   height: 40,
//                                   child: Center(
//                                     child: Text(
//                                       "Sort &\n Filter",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 10,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(25),
//                                     border: Border.all(color: Colors.grey[400]),
//                                   ),
//                                   width: 90,
//                                   height: 35,
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         "Budget",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 10,
//                                             color:
//                                                 cnst.appPrimaryMaterialColor),
//                                       ),
//                                       Icon(
//                                         Icons.keyboard_arrow_down,
//                                         color: Colors.grey,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(25),
//                                     border: Border.all(color: Colors.grey[400]),
//                                   ),
//                                   width: 70,
//                                   height: 35,
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         "BHK",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 10,
//                                             color:
//                                                 cnst.appPrimaryMaterialColor),
//                                       ),
//                                       Icon(
//                                         Icons.keyboard_arrow_down,
//                                         color: Colors.grey,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(25),
//                                     border: Border.all(color: Colors.grey[400]),
//                                   ),
//                                   width: 80,
//                                   height: 35,
//                                   child: Center(
//                                       child: Text(
//                                     "Verified",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 10,
//                                         color: cnst.appPrimaryMaterialColor),
//                                   )),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(25),
//                                     border: Border.all(color: Colors.grey[400]),
//                                   ),
//                                   width: 130,
//                                   height: 35,
//                                   child: Center(
//                                       child: Text(
//                                     "Ready to move",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 10,
//                                         color: cnst.appPrimaryMaterialColor),
//                                   )),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(25),
//                                     border: Border.all(color: Colors.grey[400]),
//                                   ),
//                                   width: 110,
//                                   height: 35,
//                                   child: Center(
//                                       child: Text(
//                                     "With Photos",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 10,
//                                         color: cnst.appPrimaryMaterialColor),
//                                   )),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(25),
//                                     border: Border.all(color: Colors.grey[400]),
//                                   ),
//                                   width: 80,
//                                   height: 35,
//                                   child: Center(
//                                       child: Text(
//                                     "New",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 10,
//                                         color: cnst.appPrimaryMaterialColor),
//                                   )),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(25),
//                                     border: Border.all(color: Colors.grey[400]),
//                                   ),
//                                   width: 80,
//                                   height: 35,
//                                   child: Center(
//                                       child: Text(
//                                     "Resale",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 10,
//                                         color: cnst.appPrimaryMaterialColor),
//                                   )),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(25),
//                                     border: Border.all(color: Colors.grey[400]),
//                                   ),
//                                   width: 80,
//                                   height: 35,
//                                   child: Center(
//                                       child: Text(
//                                     "Owner",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 10,
//                                         color: cnst.appPrimaryMaterialColor),
//                                   )),
//                                 ),
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(left: 8.0, right: 8),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(25),
//                                     border: Border.all(color: Colors.grey[400]),
//                                   ),
//                                   width: 80,
//                                   height: 35,
//                                   child: Center(
//                                       child: Text(
//                                     "Exclusive",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 10,
//                                         color: cnst.appPrimaryMaterialColor),
//                                   )),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 50,
//                       height: 50,
//                       color: Colors.white,
//                       child: Padding(
//                         padding:
//                             const EdgeInsets.only(left: 8.0, top: 5, bottom: 5),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(0),
//                             color: Colors.grey,
// //                            border: Border.all(color: Colors.grey[400]),
//                           ),
//                           width: 50,
//                           child: Center(
//                               child: Icon(
//                             Icons.tune,
//                             color: Colors.white,
//                           )),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 7),
                    itemCount: widget.searchpropertylistdata.length,
                    itemBuilder: (BuildContext Context, int index) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.05,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:5.0),
                                        child: Text(
                                          "${widget.searchpropertylistdata[index]['MemberName']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Text(" - "),
                                      Text(
                                        "${widget.searchpropertylistdata[index]['ChapterName']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ],

                                  ),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                      // Image.network(
                                      //   "https://img.staticmb.com/mbphoto/property/cropped_images/2020/Feb/22/Photo_h300_w450/48245597_1_PropertyImage372-0894901168542_300_450.jpg",
                                      //   fit: BoxFit.cover,
                                      //   width: 150,
                                      //   height: 100,
                                      // // ),
                                      widget.searchpropertylistdata[0]["Data"].length !=0 ? Image.network(
                                        widget.searchpropertylistdata[0]["Data"][_pos]["Photo"],
                                        width: 150,
                                        height: 100,
                                        gaplessPlayback: true,
                                      ) : Align(
                                          child: SizedBox(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top:50.0,left: 10,right: 10),
                                                child: Text("No Image Selected",),
                                              ),
                                          height: 95,
                                          ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 12,
                                        ),
                                        Text(
                                          "${widget.searchpropertylistdata[0]['Ptype']}",
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("₹ ${widget.searchpropertylistdata[index]['Price']} Lac",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: cnst
                                                    .appPrimaryMaterialColor,
                                                fontSize: 15)),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                  top: 8,
                                                  bottom: 8),
                                              child: Text("${widget.searchpropertylistdata[index]['Nature']}",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[700])),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text("${widget.searchpropertylistdata[index]['AreaValue']} sqft",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: cnst
                                                          .appPrimaryMaterialColor)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "${widget.searchpropertylistdata[index]['Area']}",
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12),
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //       left: 3),
                                            //   child: Text("0.8 Km away",
                                            //       style: TextStyle(
                                            //           color: Colors.grey[700],
                                            //           fontSize: 12)),
                                            // ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, right: 8, bottom: 8),
                                          child: Text("${widget.searchpropertylistdata[index]['Address']}",
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width *0.45,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.deepPurple),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
//                                      color: Colors.deepPurple,
                                      onPressed: () {
                                        void launchWhatsApp(
                                            {@required String phone,
                                              @required String message,
                                            }) async {
                                          String url() {
                                            if (Platform.isIOS) {
                                              return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
                                            } else {
                                              return "whatsapp://send?   phone=${widget.searchpropertylistdata[index]['MobileNo']}&text=${Uri.parse(message)}";
                                            }
                                          }

                                          if (await canLaunch(url())) {
                                            await launch(url());
                                          } else {
                                            throw 'Could not launch ${url()}';
                                          }
                                        }
                                        launchWhatsApp(phone: widget.searchpropertylistdata[index]['MobileNo'], message: "Hi, this is ${widget.searchpropertylistdata[index]['MemberName']} from ${widget.searchpropertylistdata[index]['ChapterName']}");
                                      },
                                      child: Row(
                                        children: [
                                         Image.asset("images/social/whatsapp.png",
                                         height: 25,
                                         ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Message",
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],

                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.45,
                                    child: FlatButton(
                                      color: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.deepPurple),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
//                                      color: Colors.deepPurple,
                                      onPressed: () async{
                                        String telephoneUrl = "tel:${widget.searchpropertylistdata[index]['MobileNo']}";

                                        if (await canLaunch(telephoneUrl)) {
                                          await launch(telephoneUrl);
                                        } else {
                                          throw "Can't phone that number.";
                                        }
                                      },
                                      child: Row(
                                        children: <Widget>[
//                                          SizedBox(
//                                              child: Image.asset(
//                                                  "assets/whatsapp1.png")),
                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0,right: 5),
                                          child: Icon(Icons.call,color: Colors.white,
                                          size: 18,),
                                        ),
                                          Text(
                                            "Call Owner",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),

    );
  }
}
