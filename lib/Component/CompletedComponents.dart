import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;


class CompletedComponents extends StatefulWidget {
  var list;

  CompletedComponents(this.list);

  @override
  _CompletedComponentsState createState() => _CompletedComponentsState();
}

class _CompletedComponentsState extends State<CompletedComponents> {

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
          padding: EdgeInsets.all(12),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${widget.list["Title"]}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: cnst.appPrimaryMaterialColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    'Completed Date : ${widget.list["Date"].substring(8,10)}-'"${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.list["Date"].substring(0,10)).toString()))}-${widget.list["Date"].substring(0,4)}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: cnst.appPrimaryMaterialColor,
                        fontSize: 15
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
