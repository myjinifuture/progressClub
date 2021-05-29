import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IdeaBookDisplay extends StatefulWidget {
  final String title;
  IdeaBookDisplay({this.title});
  @override
  _IdeaBookDisplayState createState() => _IdeaBookDisplayState();
}

class _IdeaBookDisplayState extends State<IdeaBookDisplay> {
  Future<dynamic> getContent() async {
    final url = "https://next.json-generator.com/api/json/get/4kLkDNVht";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonContent = jsonDecode(response.body);
      return jsonContent;
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: FutureBuilder<dynamic>(
          future: getContent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 11, // the length
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        shadowColor: Colors.deepPurple,
                        elevation: 3.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              // leading: FlutterLogo(size: 56.0),
                              title: Text(
                                snapshot.data[index]["content"],
                              ),
                              // subtitle: Text('Item 1 subtitle'),
                              trailing:
                                  snapshot.data[index]["isChecked"] == true
                                      ? Icon(Icons.check)
                                      : null,
                              onTap: () {
                                setState(() {
                                  snapshot.data[index]["isChecked"] =
                                      !(snapshot.data[index]["isChecked"]);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
