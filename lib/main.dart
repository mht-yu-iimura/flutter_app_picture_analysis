import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import './photoCardList.dart';

// 使用できるカメラのリストを作成
List<CameraDescription> cameras;

// 非同期処理で使用できるカメラを取得しながらアプリを起動する
Future<Null> main() async {
  // カメラの取得
  cameras = await availableCameras();

  // アプリの起動
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: CameraWidget(),
//      home: MyHomePage(title: 'Flutter Picture Analysis'),
    );
  }
}

class CameraWidget extends StatefulWidget {
  @override
  CameraWidgetState createState() {
    return CameraWidgetState();
  }

}


class CameraWidgetState extends State<CameraWidget> {
  // camera
  CameraController cameraController;

  // ???
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // 写真ファイル名に使用するタイムスタンプを取得
  String timestamp() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  // SnackBarでメッセージを表示
  void showInSnackBar(String message) =>
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = Scaffold(
      key: scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: cameraPreviewWidget(),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                // カメラ撮影ボタン
                icon: const Icon(Icons.camera_alt),
                onPressed: cameraController != null && cameraController.value.isInitialized ? onTakePictureButtonPressed : null,
              ),
              IconButton(
                // 次の画面へ
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PhotoCardList(),
                      ),
                    );
                  }
              ),
            ],
          ),
        ],
      ),
    );


    // カメラのセットアップ
    if (cameraController == null) {
      setupCamera(cameras[0]);
    }
    return scaffold;
  }


  // カメラプレビュー画面のパーツ
  Widget cameraPreviewWidget() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      // カメラの準備ができるまではテキストを表示
      return const Text('Tap a camera');
    } else {
      // 準備ができたらプレビューを表示
      return AspectRatio(
        aspectRatio: cameraController.value.aspectRatio,
        child: CameraPreview(cameraController),
      );
    }
  }

  // camera setup
  void setupCamera(CameraDescription cameraDescription) async {

    if (cameraController != null) {
      // 使い終わったカメラの解放
      await cameraController.dispose();
    }
    cameraController = CameraController(cameraDescription, ResolutionPreset.high);

    // カメラの情報が更新されたら呼ばれるリスナーの設定
    cameraController.addListener(() {
      if (mounted) setState(() {
        // 準備が終わったら再度buildする
      });
      if (cameraController.value.hasError) {
        // エラーはSnackBarで表示
        showInSnackBar('Camera error ${cameraController.value.errorDescription}');
      }
    });

    // init
    await cameraController.initialize();

    if (mounted) {
      setState(() {});
    }
  }


  // 撮影ボタンタップで撮影＋画像保存
  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {});
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });

  }

  // 画像保存をする処理
  Future<String> takePicture() async {
    if (!cameraController.value.isInitialized) {
      return null;
    }

    // Applicationのディレクトリを取得
    final Directory extDir = await getApplicationDocumentsDirectory();

    // 保存パス
    final String dirPath = '${extDir.path}/Pictures/photo';

    // 保存用ディレクトリ作成
    await Directory(dirPath).create(recursive: true);

    // ファイルパス
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (cameraController.value.isTakingPicture) {
      // 撮影済みだったら何もしない
      return null;
    }

    await cameraController.takePicture(filePath);
    return filePath;

  }

}
