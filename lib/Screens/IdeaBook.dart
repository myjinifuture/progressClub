import 'package:flutter/material.dart';
import 'package:progressclubsurat_new/Common/Constants.dart' as cnst;

class IdeaBook extends StatefulWidget {
  @override
  _IdeaBookState createState() => _IdeaBookState();
}

class _IdeaBookState extends State<IdeaBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Idea Book'),
        // backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Idea Book',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosq.',
                  textAlign: TextAlign.justify),
            ),
            SizedBox(
              height: 70,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/SelectIdeaBook');
              },
              child: const Text(
                'Get Started!',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              color: cnst.appPrimaryMaterialColor,
            )
          ],
        ),
      ),
    );
  }
}
