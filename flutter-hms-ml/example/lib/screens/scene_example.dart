/*
    Copyright 2020. Huawei Technologies Co., Ltd. All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License")
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

import 'package:flutter/material.dart';
import 'package:huawei_ml/huawei_ml.dart';
import 'package:huawei_ml_example/services/image_path_provider.dart';
import 'package:huawei_ml_example/widgets/detection_button.dart';
import 'package:huawei_ml_example/widgets/detection_result_box.dart';
import 'package:image_picker/image_picker.dart';

class SceneExample extends StatefulWidget {
  @override
  _SceneExampleState createState() => _SceneExampleState();
}

class _SceneExampleState extends State<SceneExample> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  MLSceneDetectionAnalyzer analyzer;
  MLSceneDetectionAnalyzerSetting setting;

  String _sceneResult;
  double _confidence;

  @override
  void initState() {
    _checkPermissions();
    analyzer = new MLSceneDetectionAnalyzer();
    setting = new MLSceneDetectionAnalyzerSetting();
    super.initState();
  }

  _checkPermissions() async {
    if (await MLPermissionClient().checkCameraPermission()) {
      print("Permissions are granted");
    } else {
      await MLPermissionClient().requestCameraPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(title: Text("Scene Detection")),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              detectionResultBox("Result", _sceneResult),
              detectionResultBox("Confidence", _confidence),
              SizedBox(height: 20),
              detectionButton(
                  onPressed: _showImagePickingOptions, label: "START ANALYZING")
            ],
          ),
        ));
  }

  _startDetection() async {
    try {
      final List<MLSceneDetection> scenes =
          await analyzer.syncSceneDetection(setting);
      setState(() {
        _sceneResult = scenes.first.result;
        _confidence = scenes.first.confidence;
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  _showImagePickingOptions() async {
    scaffoldKey.currentState.showBottomSheet((context) => Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text("USE CAMERA"),
                      onPressed: () async {
                        final String path = await getImage(ImageSource.camera);
                        setting.path = path;
                        _startDetection();
                      })),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text("PICK FROM GALLERY"),
                      onPressed: () async {
                        final String path = await getImage(ImageSource.gallery);
                        setting.path = path;
                        _startDetection();
                      })),
            ],
          ),
        ));
  }
}
