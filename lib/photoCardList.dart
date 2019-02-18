import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import './photoCard.dart';


class PhotoCardList extends StatefulWidget {
  PhotoCardList();

  @override
  State<StatefulWidget> createState() => PhotoCardListState();

}

class PhotoCardListState extends State<PhotoCardList> {

  // 保存されてるファイル情報を取得する
  List<String> imageFileNameList = [];
  List<String> imageFilePathList = [];
  List<File> imageFileList = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    loadImageFile();
    super.initState();
  }

  // Viewを表示
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              'saved images list',
          ),
        ),

      body:

      ListView.builder(
          itemCount: imageFileNameList.length,
          itemBuilder: (context, int index) {
            return new GestureDetector(
              // tap event
//              onTap: () => print(imageFileNameList[index]),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PhotoCard(scaffoldKey, imageFileList[index]),
                  ),
                );
              },

              child: new Card(
                child: new Column(
                  children: <Widget>[

                    // text area
                    new Padding(
                        padding: new EdgeInsets.all(8.0),
                        child: new Text(imageFileNameList[index]),
                    ),

                    // image area
                    new Padding(
                      padding: new EdgeInsets.only(bottom: 16.0),
                      child:
                        new Image.memory(
                          imageFileList[index].readAsBytesSync(),
                          width: 200,
                          height: 100,
                        ),
                    ),

                  ],
                ),
              ),

            );

          })
    );
  }

  // ignore: missing_return
  Future<List<FileSystemEntity>> loadImageFile() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/photo';

    Directory saveDir = Directory(dirPath);
    List<FileSystemEntity> imageFiles = saveDir.listSync(recursive: false, followLinks: false);
    

    if (imageFiles.isNotEmpty) {
      setState(() {
        // load image file name
        imageFiles.forEach((e) =>
            imageFileNameList.add(e.uri.pathSegments.last.split('\.').first)
        );

        // load image file path
        imageFiles.forEach((e) =>
            imageFilePathList.add(e.path)
        );

        // load image file
        imageFiles.forEach((e) =>
            imageFileList.add(File(e.path))
        );

      });
    }

  }
}