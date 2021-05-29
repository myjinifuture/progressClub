import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;
import 'package:progressclubsurat_new/Common/Constants.dart';
import 'package:progressclubsurat_new/Screens/MemberDirectory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DirectoryComponents extends StatefulWidget {
  var directory;

  DirectoryComponents(this.directory);
  @override
  _DirectoryComponentsState createState() => _DirectoryComponentsState();
}

class _DirectoryComponentsState extends State<DirectoryComponents> {

  saveChapterId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.tempChapterId,widget.directory["ChapterId"].toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberDirectory(
            chapterName:widget.directory["ChapterName"],
      ),
    ));
    //Navigator.pushNamed(context, '/MemberDirectory');
  }

  saveCommitiesId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.tempChapterId,widget.directory["ChapterId"].toString());
    await prefs.setString(Session.CommitieId,widget.directory["ChapterId"].toString());
    Navigator.pushNamed(context, '/CommitieScreen');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemberDetails()));
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Card(
          elevation: 2,

          shape: RoundedRectangleBorder(
            //side: BorderSide(color: cnst.appcolor)),


            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 2,
              shadowColor: Colors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),topLeft: Radius.circular(10.0)),
                    ),
                    width: MediaQuery.of(context).size.width,

                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${widget.directory["ChapterName"]}',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),


                  Container(
                    child: Row(

                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              //Navigator.pushReplacementNamed(context, '/MemberDirectory');
                              saveChapterId();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0)),
                              ),
                              width: MediaQuery.of(context).size.width *0.44,
                              height: 40,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *0.035,
                                    width: MediaQuery.of(context).size.width *0.07,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),

                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${widget.directory["MemberCount"]}',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text("  "),
                                  Text(
                                    'Member',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: cnst.appPrimaryMaterialColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, '/JustJoined');
                              saveCommitiesId();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0)),
                              ),
                              height: 40,
                              width: MediaQuery.of(context).size.width *0.44,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *0.035,
                                    width: MediaQuery.of(context).size.width *0.07,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),

                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${widget.directory["CommitieCount"]}',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text("  "),
                                  Text(
                                    'Commities',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: cnst.appPrimaryMaterialColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
