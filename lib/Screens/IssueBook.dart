import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/GetBookReviewComponent.dart';

class IssueBook extends StatefulWidget {
  var title, author, id;

  IssueBook({this.title, this.author, this.id});

  @override
  _IssueBookState createState() => _IssueBookState();
}

//pop dialog box for review and rating on  write review button click

class _IssueBookState extends State<IssueBook> {
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  String _format = 'yyyy-MMMM-dd';

  bool isLoading = false;

  //from date coding
  DateTime _fromDateTime = DateTime.now();

  DateTime _toDateTime = DateTime.now().add(Duration(days: 15));

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return RatingDialog(id: '${widget.id}');
      },
    );
  }

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = date == "" || date == null
          ? ""
          : "${tempDate[2].toString().substring(0, 2)}-${tempDate[1].toString()}-${tempDate[0].toString()}"
              .toString();
    }

    return final_date;
  }

  void _showDatePickerFrom() {
    DatePicker.showDatePicker(
      context,
      dateFormat: _format,
      locale: _locale,
      initialDateTime: _fromDateTime,
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _fromDateTime = dateTime;
          _toDateTime = _fromDateTime.add(Duration(days: 15));
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _fromDateTime = dateTime;
          _toDateTime = _fromDateTime.add(Duration(days: 15));
        });
      },
    );
  }

//to date coding
//  var now = DateTime.now().add(new Duration(days: 15)).toString();

  void _showDatePickerTo() {
    DatePicker.showDatePicker(
      context,
      dateFormat: _format,
      initialDateTime: _toDateTime,
      locale: _locale,
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _toDateTime = dateTime;
          _fromDateTime = _toDateTime.subtract(Duration(days: 15));
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _toDateTime = dateTime;
          _fromDateTime = _toDateTime.subtract(Duration(days: 15));
        });
      },
    );
  }

  @override
  void initState() {
    getBookReview();
  }

  List booklistData = [];

  getBookReview() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetBookReview('${widget.id}');
        res.then((data) async {
          if (data != "" && data.length > 0) {
            setState(() {
              isLoading = false;
              booklistData = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          Fluttertoast.showToast(msg: "Something Went Wrong");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Image.asset(
                      "images/missingbook.png",
                      width: 150,
                      height: 200,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "${widget.title}",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3, top: 10),
                          child: Text(
                            " Author : ",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 3),
                          child: Text(
                            "${widget.author}",
                            style: TextStyle(
                                fontFamily: 'Montserrat', fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
//              Padding(
//                padding: const EdgeInsets.all(10.0),
//                child: Text(
//                  "Description : ",
//                  style: TextStyle(
//                      fontFamily: 'Montserrat',
//                      fontSize: 18,
//                      color: Colors.black,
//                      fontWeight: FontWeight.bold),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(
//                    top: 5, left: 10, right: 10, bottom: 10),
//                child: Text(
//                  "   Unposted Letter shows us the path to understanding our subconscious mind, which helps us face the truth and manage our everyday struggles in a better way.",
//                  style: TextStyle(
//                      fontFamily: 'Montserrat', fontSize: 16, color: Colors.grey),
//                ),
//              ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "  From Date : ",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                height: 40,
                                width: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _showDatePickerFrom();
                                  },
                                  child: Center(
                                    child: Text(
                                      setDate(_fromDateTime.toString()),
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 25),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "  To Date : ",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 40,
                              width: 90,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _showDatePickerTo();
                                },
                                child: Center(
                                  child: Text(
                                    setDate(_toDateTime.toString()),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.only(top:45.0,left: 20,right: 20),
//              child:
//              Container(
//                height: 40,
//                width: MediaQuery.of(context).size.width,
//                decoration: BoxDecoration(
//                  color: Colors.deepPurple,
//                  borderRadius: BorderRadius.circular(15),
//                ),
//                child: Center(child: Text("Book Issue", style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)),
//              ),
//            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  height: 40,
                  width: 300,
                  child: FlatButton(
                    onPressed: () {
                      _issueBook();
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.deepPurple,
                    child: Text(
                      "Issue Book",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  height: 40,
                  width: 300,
                  child: FlatButton(
                    onPressed: () {
                      _showDialog(context);
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.deepPurple,
                    child: Text(
                      "Write Review",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25, bottom: 8, top: 40),
              child: Container(
                height: MediaQuery.of(context).size.height - 600,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: booklistData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GetBookReviewComponent(booklistData[index]);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

//  Widget _ratingBar(int mode) {
//    switch (mode) {
//      case 1:
//        return RatingBar(
//          initialRating: 2,
//          minRating: 1,
//          direction: _isVertical ? Axis.vertical : Axis.horizontal,
//          allowHalfRating: true,
//          unratedColor: Colors.amber.withAlpha(50),
//          itemCount: 5,
//          itemSize: 30.0,
//          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//          itemBuilder: (context, _) => Icon(
//            _selectedIcon ?? Icons.star,
//            color: Colors.amber,
//          ),
//          onRatingUpdate: (rating) {
//            setState(() {
//              _rating = rating;
//            });
//          },
//        );
//    }
//  }

  _issueBook() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        //,edtReviewController.text
        Future res = Services.SaveIssueBook(
            widget.id, _fromDateTime.toString(), _toDateTime.toString());
        res.then((data) async {
          if (data.IsSuccess == true) {
            setState(() {
              isLoading = false;
              // booklistData = data;
            });
            Fluttertoast.showToast(msg: "Book Issued Successfully!!!");
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          Fluttertoast.showToast(msg: "Something Went Wrong");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }
}

class RatingDialog extends StatefulWidget {
  var title, author, id;

  RatingDialog({this.title, this.author, this.id});

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  TextEditingController edtReviewController = new TextEditingController();
  var _ratingController = TextEditingController();
  double _rating;

  bool isLoading = false;

  //double _userRating = 3.0;
  int _ratingBarMode = 1;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData _selectedIcon;

  DateTime _fromDateTime = DateTime.now();

  @override
  void initState() {
    //_ratingController.text;
    _ratingController.text = "3.0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Add Review",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 140,
//
            child: TextFormField(
              controller: edtReviewController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, top: 18, right: 10),
                  hintText: "Write Review",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      borderSide: BorderSide(color: Colors.grey, width: 2))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Avg Rating",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Directionality(
              textDirection: _isRTLMode ? TextDirection.rtl : TextDirection.ltr,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      _heading('Rating Us'),
                      _ratingBar(_ratingBarMode),
                      SizedBox(
                        height: 20.0,
                      ),
                      _rating != null
                          ? Text(
                              "Rating: $_rating",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: new Text(
            "Not Now",
            style: TextStyle(color: Colors.deepPurple, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text(
            "Submit",
            style: TextStyle(color: Colors.deepPurple, fontSize: 18),
          ),
          onPressed: () {
            _bookReview();
            // _bookReview(widget.id);
          },
        ),
      ],
    );
  }

  Widget _ratingBar(int mode) {
    return RatingBar(
      initialRating: 0,
      // minRating: 1,
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      allowHalfRating: true,
      unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 30.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
      },
    );
  }

  Widget _heading(String text) => Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      );

  _bookReview() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        //,edtReviewController.text
        Future res = Services.SaveBookReview(
            widget.id,
            _fromDateTime.toString(),
            edtReviewController.text,
            _rating.toString());
        res.then((data) async {
          if (data.IsSuccess == true) {
            setState(() {
              isLoading = false;
              edtReviewController.text = "";
            });
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Thank you for Rating!!!");
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          Fluttertoast.showToast(msg: "Something Went Wrong");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }
}
