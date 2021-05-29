import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'dart:async';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MultipleImagePicker extends StatefulWidget {
  String propertyid = "";
  MultipleImagePicker({this.propertyid});
  @override
  _MultipleImagePickerState createState() => new _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  List files = [];
  List<Asset> resultList;

  @override
  void initState() {
    super.initState();
    print("property id");
    print(widget.propertyid);
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        print(asset.getByteData(
          quality: 100,
        ));
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  int imageslength;
  int ontap;

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        )
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      print("length of images");
      imageslength = images.length;
      print(images.length);
      _error = error;
    });
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ProgressDialog pr;
  String _path;
  String _fileName;
  String basename;
  var file;
  List extension=[];
  int x;

  getImageFileFromAsset(String path) async{
    File file = File(path);
     basename = file.path;
    return file;
  }

  _uploadBrochure() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData formData;
        List data = [];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String MemberId = prefs.getString(cnst.Session.MemberId);
        for (int i = 0; i < images.length; i++) {
          var path2 =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
          file = await getImageFileFromAsset(path2);
          String fname=basename.split('/').last;
          String ext1=fname.split('.').last;
          var base64Image = base64Encode(file.readAsBytesSync());
          data.add(await MultipartFile.fromFile(path2,
              filename: base64Image));
          files.add(base64Image);

        formData = new FormData.fromMap({
          "type": "updatephotos",
          "memberId": MemberId,
          "extension": ext1,
          "propertyid": widget.propertyid,
          "File": (file != null && file != '')
              ? data
              : null
        });
        data.clear();

         x=0;
        Services.uploadBrochure(formData).then((data) async {
          // pr.hide();
          if (data.MESSAGE == "") {
            showMsg("Please Pick Atleast One Image To Upoad");
          } else {
            x=1;
            //showMsg(data.MESSAGE);
          }
        }, onError: (e) {
          //pr.hide();
          showMsg("Try Again.");
        });

      }
        if(x==0){
          showMsg("Successfully Updated");
        }
        else{
          showMsg("Please Pick Atleast One Image To Upoad");
        }
        extension.clear();
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      //pr.hide();

      showMsg("No Internet Connection.");
    }
  }



  _submit() async {
    for (int i = 0; i < images.length; i++) {

      var path2 = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      var file = await getImageFileFromAsset(path2);
      var base64Image = base64Encode(file.readAsBytesSync());
      files.add(base64Image);
      var data = {
        "type": "updatephotos",
        "memberId": "1",
        "propertyid" : "1",
      files: files,
    };
      String url = "http://pmc.studyfield.com/Service.asmx/" + 'UpdatePhotos';
    try {
      print("anirudh");
      var response = await dio.post(url, data: data);
    var body = jsonDecode(response.data.toString());
    print("data of all files");
    print(body);
    } catch (e) {
    return e.message;
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return
       new Scaffold(
        appBar: new AppBar(
          title: const Text('Select Images'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: [
                RaisedButton(
                  child: Text("Pick images",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: loadAssets,
                ),
                RaisedButton(
                  child: Text("Upload images",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: (){
                    _uploadBrochure();
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Expanded(
              child: buildGridView(),
            ),
          ],
        ),

    );
  }
}