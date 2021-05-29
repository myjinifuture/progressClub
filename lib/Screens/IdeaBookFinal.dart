import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Models/IdeaTitleModel.dart';
import 'package:http/http.dart' as http;
import 'package:progressclubsurat_new/Screens/IdeaBookDisplay.dart';

class IdeaBookFinal extends StatefulWidget {
  @override
  _IdeaBookFinalState createState() => _IdeaBookFinalState();
}

class _IdeaBookFinalState extends State<IdeaBookFinal> {
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

  Future<IdeaTitleModel> getTitle() async {
    final url = "https://progressclub.herokuapp.com/admin/getTitle";
    final response = await http.post(url);

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
        title: Text('My Idea Books'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: FutureBuilder<IdeaTitleModel>(
            future: getTitle(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final ideaTitle = snapshot.data;
                List<Datum> filterTitle = [];
                for (int i = 0; i < ideaTitle.count; i++) {
                  if (ideaTitle.data[i].isActive == true) {
                    filterTitle.add(ideaTitle.data[i]);
                  }
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .85,
                      crossAxisCount: 3,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 2.0),
                  itemCount: filterTitle.length,
                  itemBuilder: (BuildContext context, int index) {
                    String title = filterTitle[index]
                        .title; //for passing this title to next screen's appbar title
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new IdeaBookDisplay(title: title)));
                      },
                      child: new Card(
                        // color: Colors.deepPurple,
                        elevation: 6.5,
                        shadowColor: Colors.deepPurple,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://picsum.photos/250?image=9"),
                                fit: BoxFit.fill),
                          ),
                          child: new GridTile(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                filterTitle[index].title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded, color: Colors.white, size: 30),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/SelectIdeaBook');
        },
        backgroundColor: cnst.appPrimaryMaterialColor,
        tooltip: 'Add more Idea Books',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
