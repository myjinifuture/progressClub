import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadComponents extends StatefulWidget {
  var download;

  DownloadComponents(this.download);

  @override
  _DownloadComponentsState createState() => _DownloadComponentsState();
}

class _DownloadComponentsState extends State<DownloadComponents> {
  static var httpClient = new HttpClient();
  bool downloading = false;
  var progressString = "";

  Future<void> _downloadFile(String url) async {
    Dio dio = Dio();
    try {
      var dir = await getExternalStorageDirectory();
      print("${dir.path}/${url.substring(19)}");
      await dio.download(
          "http://pmc.studyfield.com/${url.replaceAll(" ", "%20")}",
          "${dir.path}/${url.substring(19)}", onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemberDetails()));
        launch("http://pmc.studyfield.com/${widget.download["FilePath"]}"
            .replaceAll(" ", "%20"));
      },
      child: Container(
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
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'images/icon_pdf.png',
                          height: 40,
                          width: 35,
                          fit: BoxFit.fill,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${widget.download["Title"]}',
                                  style: TextStyle(
                                      color: cnst.appPrimaryMaterialColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
                        /*GestureDetector(
                          onTap: () {
                            _downloadFile(widget.download["FilePath"]);
                          },
                          child: ClipOval(
                            child: Image.asset(
                              'images/icon_download1.png',
                              height: 45,
                              width: 45,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),*/
                        /*downloading
                            ? Container(
                          height: 30,
                          width: 45,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                      Text(
                                        'Downloading File: $progressString',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _downloadFile(widget.download["FilePath"]);
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    'images/icon_download1.png',
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),*/
                        Platform.isAndroid
                            ? GestureDetector(
                                onTap: () {
                                  _downloadFile(widget.download["FilePath"]);
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    'images/icon_download1.png',
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
                Platform.isAndroid
                    ? downloading
                        ? Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Container(
                                height: 45.0,
                                width: 45.0,
                                child: Card(
                                  color: Colors.black,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Downloading File: $progressString',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container()
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
