import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class GetBookReviewComponent extends StatefulWidget {
  var reviewData;

  GetBookReviewComponent(this.reviewData);

  @override
  _GetBookReviewComponentState createState() => _GetBookReviewComponentState();
}

class _GetBookReviewComponentState extends State<GetBookReviewComponent> {
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
    return Container(
      width: 255,
      child: Card(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top:4.0),
                      child: Text(
                        "${widget.reviewData["ReviewDate"]}",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    "${widget.reviewData["Member"]}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //smainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SmoothStarRating(
                          allowHalfRating: false,
                          isReadOnly: true,
                          /*onRatingChanged:
                                    (v) {
                                  rating = v;
                                  setState(() {});
                                },*/
                          starCount: 5,
                          rating: double.parse(
                            "${widget.reviewData["Rating"]}",
                          ),
                          size: 25.0,
                          color: Colors.amber,
                          //borderColor: Colors.green,
                          spacing: 0.0),
                      _rating != "" || _rating != null
                          ? Text(
                              "${widget.reviewData["Rating"]}",
                              // "$_rating",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "${widget.reviewData["Review"]}",
                    style: TextStyle(fontSize: 16),
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
