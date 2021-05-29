import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> _contacts = new List<Contact>();
  List<CustomContact> _uiCustomContacts = List<CustomContact>();
  List<CustomContact> _searchContact = List<CustomContact>();

  //List<CustomContact> _allContacts = List<CustomContact>();
  bool _isLoading = false, isSearching = false;
  List _selectedContact = [];
  String memberId;

  TextEditingController txtSearch = new TextEditingController();

  @override
  void initState() {
    refreshContacts();
  }

  refreshContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    memberId = prefs.getString(Session.MemberId);
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    setState(() {
      _uiCustomContacts =
          _contacts.map((contact) => CustomContact(contact: contact)).toList();
      _searchContact =
          _contacts.map((contact) => CustomContact(contact: contact)).toList();
      _isLoading = false;
    });
  }

  ListTile _buildListTile(CustomContact c, List<Item> list) {
    return ListTile(
      leading: (c.contact.avatar.length > 0)
          ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar))
          : CircleAvatar(
              child: Text(
                c.contact.displayName.toUpperCase().substring(0, 1) ?? "",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
            ),
      title: Text(c.contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
      trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            _onChange(value, c, list);
          }),
    );
  }

  _onChange(value, CustomContact c, List<Item> list) {
    if (list.length >= 1 &&
        list[0]?.value != null &&
        c.contact.displayName != "") {
      String mobile = list[0].value.toString();
      String name = c.contact.displayName.toString();
      mobile = mobile.replaceAll(" ", "");
      mobile = mobile.replaceAll("-", "");
      mobile = mobile.replaceAll("+91", "");
      mobile = mobile.replaceAll(RegExp("^091"), "");
      mobile = mobile.replaceAll("+091", "");
      mobile = mobile.replaceAll(RegExp("^0"), "");
      print("mobile" + mobile);
      if (value) {
        if (mobile.length == 10) {
          setState(() {
            c.isChecked = value;
          });
          _selectedContact.add({
            "Id": 0,
            "Name": "${name}",
            "MobileNo": "${mobile}",
            "MemberId": "${memberId}"
          });
        } else
          Fluttertoast.showToast(
              msg: "Mobile Number Is Not Valid",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          c.isChecked = value;
        });
        for (int i = 0; i < _selectedContact.length; i++) {
          if (_selectedContact[i]["MobileNo"].toString() == mobile)
            _selectedContact.removeAt(i);
        }
      }
      print(_selectedContact);
    } else {
      Fluttertoast.showToast(
          msg: "Contact Is Not Valid",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  void searchOperation(String searchText) {
    if (searchText != "") {
      setState(() {
        _searchContact.clear();
        isSearching = true;
      });
      String mobile = "";
      for (int i = 0; i < _uiCustomContacts.length; i++) {
        String name = _uiCustomContacts[i].contact.displayName;
        var _phonesList = _uiCustomContacts[i].contact.phones.toList();
        if (_phonesList.length > 0) mobile = _phonesList[0].value;
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            mobile.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            _searchContact.add(_uiCustomContacts[i]);
          });
        }
      }
    } else {
      setState(() {
        isSearching = false;
      });
    }
  }

  _addGuest() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String memberId = prefs.getString(Session.MemberId);

        Services.AddGuestList(_selectedContact).then((data) async {
          setState(() {
            _isLoading = false;
          });
          if (data.Data == "1") {
            Fluttertoast.showToast(
                msg: "Guest Added Successfully",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pushReplacementNamed(context, "/EventGuest");
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            _isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
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
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/AddGuest");
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Choose Contacts"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/AddGuest");
              }),
          actions: <Widget>[
            _isLoading
                ? Container()
                : _selectedContact.length > 0
                    ? GestureDetector(
                        onTap: () {
                          _addGuest();
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                                width: 90,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3, right: 3, top: 2, bottom: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "Add",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ))),
                      )
                    : Container(),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: TextFormField(
                controller: txtSearch,
                onChanged: searchOperation,
                scrollPadding: EdgeInsets.all(0),
                decoration: InputDecoration(
                    counter: Text(""),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    suffixIcon: Icon(
                      Icons.search,
                      color: cnst.appPrimaryMaterialColor,
                    ),
                    hintText: "Search Contact"),
                maxLength: 10,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? LoadinComponent()
                  : _uiCustomContacts.length > 0
                      ? isSearching
                          ? ListView.builder(
                              itemCount: _searchContact?.length,
                              itemBuilder: (BuildContext context, int index) {
                                CustomContact _contact = _searchContact[index];
                                var _phonesList =
                                    _contact.contact.phones.toList();
                                return _buildListTile(_contact, _phonesList);
                              },
                            )
                          : ListView.builder(
                              itemCount: _uiCustomContacts?.length,
                              itemBuilder: (BuildContext context, int index) {
                                CustomContact _contact =
                                    _uiCustomContacts[index];
                                var _phonesList =
                                    _contact.contact.phones.toList();
                                return _buildListTile(_contact, _phonesList);
                              },
                            )
                      : NoDataComponent(),
            ),
          ],
        ),
      ),
    );
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
