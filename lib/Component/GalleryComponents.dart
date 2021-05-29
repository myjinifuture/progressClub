import 'package:flutter/material.dart';

import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Screens/EventGallaryScroll.dart';

class GalleryComponents extends StatefulWidget {
  var eventGallery;

  GalleryComponents(this.eventGallery);

  @override
  _GalleryComponentsState createState() => _GalleryComponentsState();
}

class _GalleryComponentsState extends State<GalleryComponents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Card(
        shape: RoundedRectangleBorder(
          //side: BorderSide(color: cnst.appcolor)),
          side: BorderSide(width: 0.10, color: cnst.appPrimaryMaterialColor),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Container(
          //padding: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child:
                /*Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/9/9c/Hrithik_at_Rado_launch.jpg',
              height: 100,
              fit: BoxFit.fill,
            )*/
                GestureDetector(
                  /*onTap: (){
                    print("ddd");
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            EventGallaryScroll()));
                  },*/
                  child: widget.eventGallery["EventPhoto1"] != null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'images/icon_events.jpg',
                          image: "http://pmc.studyfield.com/${widget.eventGallery["EventPhoto1"]}",
                          fit: BoxFit.fill,
                          height: 100,
                        )
                      : Image.asset(
                          'images/icon_events.jpg',
                          fit: BoxFit.fill,
                          height: 100,
                        ),
                ),
          ),
        ),
      ),
    );
  }
}
