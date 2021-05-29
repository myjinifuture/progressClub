import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class OfficeBookingDetailComponent extends StatefulWidget {
  var data;
  String memberId, TitleLabel;

  OfficeBookingDetailComponent(this.data, this.memberId, this.TitleLabel);

  @override
  _OfficeBookingDetailComponentState createState() =>
      _OfficeBookingDetailComponentState();
}

class _OfficeBookingDetailComponentState
    extends State<OfficeBookingDetailComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    child: widget.data["Image"] != null &&
                            widget.data["Image"] != ""
                        ? FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image:
                                widget.data["Image"].toString().contains("http")
                                    ? widget.data["Image"]
                                    : "http://pmc.studyfield.com/" +
                                        widget.data["Image"],
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
                          '${widget.data["PersonName"]}',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 18),
                        ),
                        Row(
                          children: <Widget>[
                            Text('Timing - '),
                            Container(
                              decoration: BoxDecoration(
                                  color: cnst.appPrimaryMaterialColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, bottom: 4, top: 4),
                                child: Text(
                                  '${widget.data["FromTime"]} To ${widget.data["ToTime"]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        widget.data["MemberId"].toString()==widget.memberId?Text(
                          'Status - ${widget.data["Status"]}',
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColor,
                              fontSize: 12),
                        ):Container(),
                        Text(
                          'Booking Purpose -'
                              ' ${widget.data["Purpose"]}',
                        ),
                      ],
                    ),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
