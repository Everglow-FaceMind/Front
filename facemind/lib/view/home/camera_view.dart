import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
  });
  @override
  State<StatefulWidget> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CameraView'),
      ),
      body: const Center(
        child: Text('CameraView'),
      ),
    );
  }
}
