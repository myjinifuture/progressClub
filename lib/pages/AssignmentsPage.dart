import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Screens/NewBusiness.dart';

class AssignmentsPage extends StatefulWidget {
  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Text("Business Given",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left:16.0,right: 16),
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),

              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text("Business Received",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left:16.0,right: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),

              ),
            ),
            SizedBox(
              height: 180,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewBusiness()),
                    );
                    setState(() {

                    });
                  },
                child: Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
