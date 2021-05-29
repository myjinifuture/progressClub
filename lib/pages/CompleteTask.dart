import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Services.dart';
import 'package:progressclubsurat_new/Component/CompletedComponents.dart';
import 'package:progressclubsurat_new/Component/LoadinComponent.dart';
import 'package:progressclubsurat_new/Component/NoDataComponent.dart';

class CompleteTask extends StatefulWidget {
  var meetingId;

  CompleteTask(this.meetingId);

  @override
  _CompleteTaskState createState() => _CompleteTaskState();
}

class _CompleteTaskState extends State<CompleteTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List>(
          future: Services.getCompletedAssi(widget.meetingId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.data.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CompletedComponents(snapshot.data[index]);
                        },
                      )
                    : NoDataComponent()
                : LoadinComponent();
          },
        ),
      ),
    );
  }
}
