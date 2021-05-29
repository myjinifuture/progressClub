import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:progressclubsurat_new/Common/Constants.dart';

class WebViewEventForm extends StatefulWidget {
  String url;
  String title;

  WebViewEventForm({this.url, this.title});

  @override
  _WebViewEventFormState createState() => _WebViewEventFormState();
}

class _WebViewEventFormState extends State<WebViewEventForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: WebviewScaffold(
        url: '${widget.url}',
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          child: const Center(
            child: CircularProgressIndicator()
          ),
        ),
      ),
    );
  }
}
