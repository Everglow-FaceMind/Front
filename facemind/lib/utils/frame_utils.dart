import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

class FrameUtil {
  final int frameBufferLenght;
  final void Function(List<imglib.Image> frames) onFrameBufferFull;

  FrameUtil({
    this.frameBufferLenght = 150,
    required this.onFrameBufferFull,
  });

  final List<imglib.Image> _frameBuffer = [];

  void addFrame(imglib.Image frame) {
    _frameBuffer.map((e) {});
    _frameBuffer.add(frame);
    if (_frameBuffer.length >= frameBufferLenght) {
      debugPrint('FrameUtil: Buffer is full!!');
      onFrameBufferFull.call(_frameBuffer);
      clear();
    }
  }

  void clear() {
    _frameBuffer.clear();
  }
}
