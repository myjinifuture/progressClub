import'dart:io';

import 'package:flutter/material.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Services.dart';
import 'DirectorySearch.dart';
//Components dart file
import 'package:progressclubsurat_new/Component/DirectoryComponents.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';

class Directory extends StatefulWidget {
  @override
  _DirectoryState createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  //loading var
  bool isLoading = false;
    List list = new List();
  TextEditingController searchController = new TextEditingController();
  @override
  void initState() {
    isLoading = true;
    // TODO: implement initState
    super.initState();
    getDirectoryFromServer();
  }
  _getSearchData()  {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> DirectorySearch(text: "${searchController.text}")));

  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
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

  getDirectoryFromServer() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetDirectory();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              list = data;

            });
          } else {
            showMsg("Try Again.");
          }
        }, onError: (e) {

          showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: cnst.appPrimaryMaterialColor,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/DirectorySearch');
              },
              child: Icon(Icons.search,color: cnst.appPrimaryMaterialColor,size: 30),
            ),
          )
        ],
        title: Text(
          'Directory',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10,10,10,00),
            height:60,
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, size: 22),
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        hintText: "Search Member Name",
                        hintStyle: TextStyle(fontSize: 13)),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (!isLoading) {
                          _getSearchData();
                        }
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.deepPurple,
                        ),
                        child: Center(
                            child: Text("Search",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white))),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          Container(
            height: MediaQuery.of(context).size.height *0.79,
            width: MediaQuery.of(context).size.width,
            child: isLoading
                ? LoadinComponent()
                : list.length != 0 && list != null
                    ? ListView.builder(
                        padding: EdgeInsets.only(top: 5),
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DirectoryComponents(list[index]);
                        })
                    : Container(
                        child: Center(
                            child: Text('No Data Found.',
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 20))),
                      ),
          ),
        ],
      ),
    );
  }
}
