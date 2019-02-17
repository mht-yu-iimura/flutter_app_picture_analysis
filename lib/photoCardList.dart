import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class PhotoCardList extends StatefulWidget {
  PhotoCardList();

  @override
  State<StatefulWidget> createState() => PhotoCardListState();

}

class PhotoCardListState extends State<PhotoCardList> {

  // 保存されてるファイル情報を取得する
  List<String> imageFileList = [];

  @override
  void initState() {
    loadImageFile();
    super.initState();
  }

  // Viewを表示
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body:

      ListView.builder(
          itemCount: imageFileList.length,

          itemBuilder: (context, int index) {

            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                imageFileList[index],
              )
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

        imageFiles.forEach((e) =>
            imageFileList.add(e.uri.pathSegments.last.split('\.').first)
        );
      });
    }

  }
}