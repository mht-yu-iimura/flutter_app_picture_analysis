import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotoCard extends StatefulWidget {
  final File imageFile;
  
  const PhotoCard(Key key, this.imageFile): super(key: key);

  @override
  State<StatefulWidget> createState() => PhotoCardState();

}

class PhotoCardState extends State<PhotoCard>{

  static String apiKey = 'AIzaSyBX2KCSpuDiPeJ3vysObUY3F7nBM3v5hiU';
  static String requestUrl = 'https://vision.googleapis.com/v1/images:annotate?key=' + apiKey;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'image analysis',
        ),
      ),

      body:
        new Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // image
              new Image.file(widget.imageFile),

              // analysis area
              analysisArea(),

            ],
          ),
        ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          new FloatingActionButton(
            child: new Icon(Icons.arrow_upward),
//            onPressed: () => print('push button'),


              onPressed: () =>

              // api call event
            http.post(
              requestUrl,
              body: {}
            ).then((response) {
              print('response');
            }),

        ),
    );
  }

  Widget analysisArea() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          new Text('score : 100'),
          new Text('discription : これはxxです')
        ],
      ),
    );
  }



}

