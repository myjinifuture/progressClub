import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Screens/EventDetail.dart';
import 'package:progressclubsurat_new/Screens/EventGallery.dart';

class EventListComponents extends StatefulWidget {
  var event;
  EventListComponents(this.event);

  @override
  _EventListComponentsState createState() => _EventListComponentsState();
}

class _EventListComponentsState extends State<EventListComponents> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetail(Event: widget.event)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${widget.event["Title"]}',
                      style: TextStyle(
                          fontSize: 16,
                          color: cnst.appPrimaryMaterialColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'images/icon_event.png',
                          height: 18,
                          width: 18,
                        ),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '${widget.event["Start_Date"].substring(8,10)}-'"${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.event["Start_Date"].substring(0,10)).toString()))}-${widget.event["Start_Date"].substring(0,4)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: cnst.appPrimaryMaterialColor,
                                ),
                              ),
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(6.0),
                        child: /*Image.network(
                      'https://png.pngtree.com/thumb_back/fh260/back_pic/03/98/85/2057f61fabc8d1b.jpg',
                      height: 180,
                      width: MediaQuery.of(context).size.width - 20,
                      fit: BoxFit.fill,
                    ),*/
                        widget.event["Photos"] != null
                            ? FadeInImage.assetNetwork(
                          placeholder: 'images/icon_events.jpg',
                          image: "http://pmc.studyfield.com/${widget.event["Photos"]}",
                          fit: BoxFit.fill,
                          height: 180,
                          width: MediaQuery.of(context).size.width - 20,
                        )
                            : Image.asset(
                          'images/icon_events.jpg',
                          fit: BoxFit.fill,
                          height: 180,
                          width: MediaQuery.of(context).size.width - 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        '${widget.event["ShortDescription"]}',
                        maxLines: 3,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),


              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: GestureDetector(
                    onTap: (){
                      //Navigator.pushReplacementNamed(context, '/EventGallery');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EventGallery(EventId: widget.event["Id"])));
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: cnst.appPrimaryMaterialColor[50]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            'images/gallery.png',
                            height: 20,
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 7),
                            child: Text(
                              'Gallery of this Event',
                              style: TextStyle(
                                  color: cnst.appPrimaryMaterialColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
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
    );
  }
}

