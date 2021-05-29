import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Screens/IssueBook.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class BookScreenComponent extends StatefulWidget {
  var bookData;
  double rating = 3.0;

  BookScreenComponent(this.bookData);

  @override
  _BookScreenComponentState createState() => _BookScreenComponentState();
}

class _BookScreenComponentState extends State<BookScreenComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ExpansionTile(
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xff4c362f),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${widget.bookData["Title"]}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Text(
                  "${widget.bookData["Author"]}",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 15.0, right: 15, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 15, bottom: 3),
                      child: Text(
                        "${widget.bookData["Subject"]}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        "${cnst.Inr_Rupee + " " + widget.bookData["Price"]}",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
                child: Text(
                  "${widget.bookData["NoOfPages"]} pages",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Montserrat'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SmoothStarRating(
                    allowHalfRating: false,
                    isReadOnly: true,

                    /*onRatingChanged:
                                      (v) {
                                    rating = v;
                                    setState(() {});
                                  },*/
                    starCount: 5,
                    rating: widget.bookData["Rating"] == ""
                        ? 0
                        : double.parse(
                            "${widget.bookData["Rating"]}",
                          ),
                    size: 25.0,
                    color: Colors.amber,
                    //borderColor: Colors.green,
                    spacing: 0.0),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
                child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${widget.bookData["Language"]}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      height: 35,
                      width: MediaQuery.of(context).size.width - 200,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IssueBook(
                                  title: "${widget.bookData["Title"]}",
                                  author: "${widget.bookData["Author"]}",
                                  id: "${widget.bookData["BookId"]}"),
                            ),
                          );
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
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
