import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhotoCard extends StatefulWidget {
  final File imageFile;
  
  const PhotoCard(Key key, this.imageFile): super(key: key);

  @override
  State<StatefulWidget> createState() => PhotoCardState();

}

class PhotoCardState extends State<PhotoCard>{

  static String exRequestUrl = 'http://tepco-usage-api.appspot.com/latest.json';
  String capacity;

  @override
  void initState() {
    capacity = '';
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

              // api call
              onPressed: () =>

              http.get(exRequestUrl).then(
                      (response) {
                print("${response.statusCode}");
                print("${response.body}");

                setState(() {

                  if (response.statusCode == 200){
                    Map<String, dynamic> decode = json.decode(response.body);
                    capacity = decode['capacity'].toString();
                    print('response OK');

                  }

                });
              })

        ),
    );
  }

  Widget analysisArea() {

    if (capacity.length < 1) {
      return Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            new Text('score : 取得できてません'),
            new Text('discription : 取得できてません')
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            new Text('score : ${capacity}'),
            new Text('discription : これはxxです')
          ],
        ),
      );
    }
  }

}

