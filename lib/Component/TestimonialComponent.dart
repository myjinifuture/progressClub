import 'dart:io';

import 'package:flutter/material.dart';

import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class TestimonialComponent extends StatefulWidget {
  var testimonial;
  Function onChange;

  TestimonialComponent(this.testimonial, this.onChange);

  @override
  _TestimonialComponentState createState() => _TestimonialComponentState();
}

class _TestimonialComponentState extends State<TestimonialComponent> {
  double rating = 3.0;
  String memberId = "";

  @override
  void initState() {
    // TODO: implement initState
    getLocalData();
    super.initState();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = await prefs.getString(Session.MemberId);

    setState(() {
      memberId = MemberId;
    });
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Error"),
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

  void _showConfirmDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Progress Club"),
          content:
              new Text("Are You Sure You Want To Delete This Testimonial."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                deleteTestimonial();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteTestimonial() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        widget.onChange("show");
        Future res =
            Services.DeleteTestimonial(widget.testimonial["Id"].toString());
        res.then((data) async {
          if (data.Data != "0") {
            setState(() {
              widget.testimonial["Id"] = "delete";
              widget.onChange("cancel");
            });
            showMsg("Testimonial Deleted Successfully");
          } else {
            widget.onChange("cancel");
            showMsg(data.Message);
          }
        }, onError: (e) {

          widget.onChange("cancel");
          showMsg("Try Again.");
        });
      } else {
        widget.onChange("cancel");
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _openWhatsapp() {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll(
        "#mobile", "91${widget.testimonial["MobileNo"]}");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  @override
  Widget build(BuildContext context) {
    return widget.testimonial["Id"].toString() == "delete"
        ? Container()
        : Container(
            width: MediaQuery.of(context).size.width - 25,
            child: Card(
              //margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, bottom: 20, top: 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topRight,
                        children: <Widget>[
                          memberId ==
                                  widget.testimonial["AddByMemberId"].toString()
                              ? Positioned(
                                  bottom: 20,
                                  right: -10,
                                  //top: 10,
                                  //left: 10,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Color(0xff5946a8),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40))),
                                    child: MaterialButton(
                                      onPressed: () {
                                        //deleteTestimonial();
                                        _showConfirmDialog();
                                      },
                                      shape: CircleBorder(),
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                ClipOval(
                                  child: widget.testimonial["Image"] != null &&
                                          widget.testimonial["Image"] != ""
                                      ? FadeInImage.assetNetwork(
                                          placeholder: 'images/icon_user.png',
                                          image: widget.testimonial["Image"]
                                                  .toString()
                                                  .contains("http")
                                              ? widget.testimonial["Image"]
                                              : "http://pmc.studyfield.com/" +
                                                  widget.testimonial["Image"],
                                          height: 40,
                                          width: 40,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${widget.testimonial["PersonName"]}",
                                        style: TextStyle(
                                            color: cnst.appPrimaryMaterialColor,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "${widget.testimonial["CompanyName"]}",
                                      ),
                                    ],
                                  ),
                                )),
                                memberId ==
                                        widget.testimonial["AddByMemberId"]
                                            .toString()
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          _openWhatsapp();
                                        },
                                        child: Image.asset(
                                          'images/whatsapp.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                memberId ==
                                        widget.testimonial["AddByMemberId"]
                                            .toString()
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          launch("tel:" +
                                              widget.testimonial['MobileNo']);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(Icons.call,
                                              size: 22,
                                              color:
                                                  cnst.appPrimaryMaterialColor),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7.0, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  SmoothStarRating(
                                      allowHalfRating: false,
                                      /*onRatingChanged:
                                    (v) {
                                  rating = v;
                                  setState(() {});
                                },*/
                                      starCount: 5,
                                      rating: double.parse(
                                        "${widget.testimonial["Rating"]}",
                                      ),
                                      size: 25.0,
                                      color: Colors.amber,
                                      //borderColor: Colors.green,
                                      spacing: 0.0),
                                ],
                              ),
                            ),
                            Text("${widget.testimonial["Description"]}",
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontWeight: FontWeight.w600)),
                          ],
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
