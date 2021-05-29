
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
class ImageRotater extends StatefulWidget {
  List<String> photos;

  ImageRotater(this.photos);

  @override
  State<StatefulWidget> createState() => new ImageRotaterState();
}

class ImageRotaterState extends State<ImageRotater> {
  int _pos = 0;
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        _pos = (_pos + 1) % widget.photos.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Image.network(
      widget.photos[_pos],
      gaplessPlayback: true,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }
}