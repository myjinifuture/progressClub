import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Models/IdeaTitleModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SelectIdeaBook extends StatefulWidget {
  @override
  _SelectIdeaBookState createState() => _SelectIdeaBookState();
}

class _SelectIdeaBookState extends State<SelectIdeaBook> {
  // List<Map> ideaTitles = [
  //   {'name': 'Sales and Business Growth', 'flag': false},
  //   {'name': 'Task and Time Management', 'flag': false},
  //   {'name': 'Relationship Development', 'flag': false},
  //   {'name': 'Health', 'flag': false},
  //   {'name': 'SOP of Business Response', 'flag': false},
  //   {'name': 'Customer Relationship', 'flag': false},
  //   {'name': 'Liquidity, Payment collection', 'flag': false},
  //   {'name': 'Leadership', 'flag': false},
  //   {'name': 'Savings', 'flag': false},
  //   {'name': 'Life and Kids Bonding', 'flag': false},
  //   {'name': 'Teamwork and Responsibility', 'flag': false},
  // ];
  final url = "https://progressclub.herokuapp.com/";
  Future<IdeaTitleModel> getTitle() async {
    // final url = "https://progressclub.herokuapp.com/admin/getTitle";
    final response = await http.post(url + "admin/getTitle");

    if (response.statusCode == 200) {
      final jsonIdeaTitle = jsonDecode(response.body);
      return IdeaTitleModel.fromJson(jsonIdeaTitle);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Idea Books'),
        actions: [
          FloatingActionButton(
            child:
                Icon(Icons.double_arrow_rounded, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/IdeaBookComponent');
            },
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<IdeaTitleModel>(
          future: getTitle(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final ideaTitle = snapshot.data;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0, bottom: 5.0),
                    child: Text(
                      'Please select your interests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  /*ListTile(
                leading: Icon(Icons.menu_book,
                    color: cnst.appPrimaryMaterialColor, size: 30),
                title: Text(
                  'Sales Growth',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {},
                trailing: Icon(Icons.check_circle_outline,
                    color: cnst.appPrimaryMaterialColor, size: 30),
              ),
              ListTile(
                leading: Icon(Icons.menu_book,
                    color: cnst.appPrimaryMaterialColor, size: 30),
                title: Text(
                  'Staff Management',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {},
                trailing: Icon(Icons.check_circle_outline,
                    color: cnst.appPrimaryMaterialColor, size: 30),
              ),
              ListTile(
                leading: Icon(Icons.menu_book,
                    color: cnst.appPrimaryMaterialColor, size: 30),
                title: Text(
                  'Self Development',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {},
                // trailing: Icon(Icons.check_circle_outline,
                //     color: cnst.appPrimaryMaterialColor, size: 30),
              ),
              ListTile(
                leading: Icon(Icons.menu_book,
                    color: cnst.appPrimaryMaterialColor, size: 30),
                title: Text(
                  'Event Organization',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {},
                // trailing: Icon(Icons.check_circle_outline,
                //     color: cnst.appPrimaryMaterialColor, size: 30),
              ),*/
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: ideaTitle.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new ListTile(
                            leading: Icon(Icons.menu_book,
                                color: cnst.appPrimaryMaterialColor, size: 30),
                            title: Text(
                              ideaTitle.data[index].title.toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: ideaTitle.data[index].isActive == true
                                ? Icon(Icons.check_circle_rounded,
                                    color: cnst.appPrimaryMaterialColor,
                                    size: 30)
                                : null,
                            dense: true,
                            onTap: () {
                              setState(() {
                                ideaTitle.data[index].isActive =
                                    !(ideaTitle.data[index].isActive);
                              });
                            },
                          );
                        }),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.double_arrow_rounded, color: Colors.white, size: 30),
      //   onPressed: () {
      //     Navigator.pushReplacementNamed(context, '/IdeaBookComponent');
      //   },
      //   backgroundColor: cnst.appPrimaryMaterialColor,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }
}
