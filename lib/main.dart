import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bdface_collect/flutter_bdface_collect.dart';
import 'package:flutter_bdface_collect/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterBdfaceCollect.instance.platformVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('百度离线人脸采集'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('开始采集: $_platformVersion\n'),
            onPressed: () {
              collectFace();
            },
          ),
        ),
      ),
    );
  }

  collectFace() async {
    print('开始初始化');
    // 这里填写百度离线采集SDK授权后的LicenseID
    String licenseID = "xxxx-face-android";
    String? err = await FlutterBdfaceCollect.instance.init(licenseID);
    print('初始化结果${err == null ? '成功' : '失败'}');
    //采集配置
    FaceConfig config =
        FaceConfig(livenessTypes: Set.from(LivenessType.all.sublist(1, 4)));
    //开始采集
    CollectResult res = await FlutterBdfaceCollect.instance.collect(config);
    print('采集错误结果:${res.error.isNotEmpty} 内容：${res.error}');
    print('采集原图imageCropBase64:${res.imageSrcBase64.isNotEmpty}');
    print('采集抠图imageSrcBase64:${res.imageCropBase64.isNotEmpty}');
    // UnInit 释放
    FlutterBdfaceCollect.instance.unInit();
  }
}
