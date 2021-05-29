import 'dart:io';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progressclubsurat_new/pages/ContactService.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

//Common Dart File
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';

//Components
import 'package:progressclubsurat_new/Component/MemberDirectoryComponent.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberDirectory extends StatefulWidget {
  var chapterName;

  MemberDirectory({this.chapterName});

  @override
  _MemberDirectoryState createState() => _MemberDirectoryState();
}

class _MemberDirectoryState extends State<MemberDirectory> {
  //loading var
  bool isLoading = true;
  List list = new List();
  List searchlist = new List();
  bool _isSearching = false, isfirst = false;
  String UserType = "";
  ProgressDialog pr;
  List<Contact> _contacts = new List<Contact>();
  List<CustomContact> _uiCustomContacts = List<CustomContact>();
  bool _isLoading = true, isSearching = false;
  List _selectedContact = [];
  List _dataPass = [];
  int i = 0;

  @override
  void initState() {
    // TODO: implement initState
    print(widget.chapterName);
    refreshContacts();
    super.initState();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    _getLocalData();
    _getContactPermission();
    getDirectoryFromServer();
  }

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UserType = prefs.getString(Session.Type);
    });
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
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
      searchlist.clear();
      //check Internet Connection
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ChapterId = prefs.getString(Session.tempChapterId);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetChapterMemberList(ChapterId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              list = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          showMsg("Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  TextEditingController _controller = TextEditingController();

  final globalKey = new GlobalKey<ScaffoldState>();
  Widget appBarTitle = new Text(
    'Member Directory',
    style: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  _saveAllToContact() async {
    pr.show();
    for (int i = 0; i < list.length; i++) {
      var chap = widget.chapterName.toString().split(" ");
      String prefix = "";
      try {
        print(chap[0] + chap[1] + chap[2]);
        if (chap[0] + chap[1] + chap[2] == "PROGRESSCLUBDIGITAL") {
          prefix = "PCD";
        } else {
          if (chap[2].length > 1) {
            prefix = chap[0].substring(0, 1) +
                chap[1].substring(0, 1) +
                chap[2].substring(0, 2) +
                " ";
          } else if (chap[2].length > 2) {
            prefix = chap[0].substring(0, 1) +
                chap[1].substring(0, 1) +
                chap[2].substring(0, 3) +
                " ";
          } else {
            prefix = chap[0].substring(0, 1) +
                chap[1].substring(0, 1) +
                chap[2].substring(0, 1) +
                " ";
          }
        }
      } catch (e) {
        prefix = "PC ";
      }
      print(prefix);
      Contact contact = Contact();
      contact.givenName = prefix + list[i]["Name"];
      contact.phones = [Item(label: "mobile", value: list[i]["MobileNo"])];
      print("contact.phones data:");
      print(contact.phones.toString());
      contact.emails = [Item(label: "work", value: list[i]["Email"])];
      contact.company = list[i]["CompanyName"];
      await ContactService.addContact(contact);

    }
    Fluttertoast.showToast(
        msg: "All Contacts Saved Successfully...",
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG);
    pr.hide();
  }

  refreshContacts() async {
    var contacts = await ContactService.getContacts(
        withThumbnails: false, photoHighResolution: false);
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    setState(() {
      _uiCustomContacts =
          _contacts.map((contact) => CustomContact(contact: contact)).toList();
    });
    setState(() {
      for (i = 0; i < _uiCustomContacts.length; i++) {
        CustomContact _contact = _uiCustomContacts[i];
        var _phonesList = _contact.contact.phones.toList();
        List<Item> list = _phonesList;
        list.length >= 1 && list[0]?.value != null
            ? _dataPass.add(list[0]
                .value
                .replaceAll("(", "")
                .replaceAll(")", "")
                .replaceAll("-", "")
                .replaceAll(" ", "")
                .replaceAll("+091", "")
                .replaceAll("0", "")
                .replaceAll(RegExp("^091"), "")
                .replaceAll("+91", ""))
            : print('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      /*appBar: AppBar(
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
        title: Text(
          'Member Directory',
          style: TextStyle(
              color: cnst.appPrimaryMaterialColor,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),*/
      appBar: buildAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:
            /*isLoading
            ? LoadinComponent()
            : list.length != 0 && list != null
                ? ListView.builder(
                    padding: EdgeInsets.only(top: 5),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MemberDirectoryComponent(list[index]);
                    })
                : Container(
                    child: Center(
                        child: Text('No Data Found.',
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 20))),
                  ),*/
            isLoading
                ? LoadinComponent()
                : list.length > 0 && list != null
                    ? Column(
                        children: <Widget>[
                          UserType.toLowerCase() != "guest"
                              ? GestureDetector(
                                  onTap: () {
                                    _saveAllToContact();
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    decoration: BoxDecoration(
                                        color: cnst.appPrimaryMaterialColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7))),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: new Text("Save All Contacts",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                )
                              : Container(),
                          Expanded(
                              child: searchlist.length != 0
                                  ? ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      itemCount: searchlist.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return MemberDirectoryComponent(
                                            searchlist[index],
                                            widget.chapterName,
                                            UserType);
                                      },
                                    )
                                  : _isSearching && isfirst
                                      ? ListView.builder(
                                          padding: EdgeInsets.all(0),
                                          itemCount: searchlist.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return MemberDirectoryComponent(
                                                searchlist[index],
                                                widget.chapterName,
                                                UserType);
                                          },
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.all(0),
                                          itemCount: list.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return MemberDirectoryComponent(
                                                list[index],
                                                widget.chapterName,
                                                UserType);
                                          },
                                        ))
                        ],
                      )
                    : NoDataComponent(),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      centerTitle: false,
      title: appBarTitle,
      actions: <Widget>[
        /*UserType.toLowerCase()!="guest"?
        Center(
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                child: new Text("Save All"),
              )),
        ):Container(),*/
        new IconButton(
          icon: icon,
          onPressed: () {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: searchOperation,
//onSubmitted: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          },
        ),
      ],
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        'Member Directory',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      );
      _isSearching = false;
      isfirst = false;
      searchlist.clear();
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchlist.clear();
    if (_isSearching != null) {
      isfirst = true;
      for (int i = 0; i < list.length; i++) {
        String name = list[i]["Name"];
        String cmpName = list[i]["CompanyName"];
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            cmpName.toLowerCase().contains(searchText.toLowerCase())) {
          searchlist.add(list[i]);
        }
      }
    }
    setState(() {});
  }
}

class CustomContact {
  final Contact contact;
  bool isChecked;

  CustomContact({
    this.contact,
    this.isChecked = false,
  });
}
