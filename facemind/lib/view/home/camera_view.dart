import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:facemind/view/home/result_view.dart';
import 'package:facemind/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as imglib;

import '../../model/user_condition.dart';
import '../../utils/global_colors.dart';

const int kStreamingSecond = 5;
const int kStreamingFrameDelayMillisecond = 200;

class Assets {
  static String userIcon = 'assets/icon/icon_user.png';
  static String cameraIcon = 'assets/icon/camera.png';
  static String flipCameraIcon = 'assets/icon/flip_camera.png';
}

// https://developers.google.com/ml-kit/vision/face-detection?hl=ko

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
  });
  @override
  State<StatefulWidget> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  // https://luvris2.tistory.com/764
  // https://pub.dev/packages/camera

  // index: 0 => 후면
  // index: 1 => 전면
  List<CameraDescription>? _cameras = [];
  CameraController? _controller;
  bool _isStremingImage = false;

  // 촬영 진행 상태
  int _progress = 0;

  // 현재 측정된 심박수
  int _value = 0;
  int _minHeartRate = 0;
  int _maxHeartRate = 0;
  int _avgHeartRate = 0;

  // select camera Index
  int _cameraIndex = 0;

  Timer? _progressTimer;
  Timer? _frameTimer;

  Uint8List? _frameImage;
  CameraImage? _bufferCameraImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    // 카메라 컨트롤러 해제
    _controller?.dispose();
    _progressTimer?.cancel();
    _frameTimer?.cancel();
    super.dispose();
  }

  void _initializeCamera() async {
    // 사용 가능한 카메라 가져오기
    final cameras = await availableCameras();

    setState(() {
      _cameras = cameras;
      if (_cameras == null || _cameras!.isEmpty) {
        Get.back();
        return;
      }

      final targetCamera = _cameras!.length > 1 ? _cameras![1] : _cameras![0];

      _controller = CameraController(
        targetCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }

        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print("CameraController Error : CameraAccessDenied");
              break;
            default:
              print("CameraController Error");
              break;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: GlobalColors.mainColor,
        ),
      );
    }

    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      appBar: DefaultAppBar(
        title: const Text('측정하기'),
      ),
      body: Container(
        padding: const EdgeInsets.all(25.0),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final maxHeight = constraints.maxHeight;
          final maxWidth = constraints.maxWidth;
          final previewHeight = maxHeight / 1.8;
          final previewWidth = previewHeight * 0.7;
          return Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center, // 좌우 정렬
                  children: [
                    const Spacer(),
                    Text(
                      _isStremingImage
                          ? '측정 중...\n움직이거나 말하지 마세요'
                          : '얼굴을 가이드 선 영역에 맞추고\n촬영 버튼을 눌러 주세요!',
                      textAlign: TextAlign.center, // 텍스트 중앙 정렬
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: previewWidth,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _isStremingImage
                            ? Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: GlobalColors.subBgColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    _value.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: GlobalColors.darkgrayColor),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: _flipCamera,
                                child: Image.asset(
                                  width: 50,
                                  Assets.flipCameraIcon,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: previewWidth,
                        height: previewHeight,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CameraPreview(_controller!),
                            ),
                            Center(
                              child: Image.asset(
                                width: previewWidth - 20,
                                height: previewWidth - 20,
                                Assets.userIcon,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 80,
                      child: _isStremingImage
                          ? Center(
                              child: SizedBox(
                                height: 40,
                                child: LinearProgressIndicator(
                                  minHeight: 80,
                                  value: _progress / kStreamingSecond,
                                  backgroundColor: GlobalColors.lightgrayColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    GlobalColors.mainColor,
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                _startImageStream();
                              },
                              child: Image.asset(
                                width: 50,
                                Assets.cameraIcon,
                              ),
                            ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              if (_frameImage != null)
                Align(
                  alignment: Alignment.topRight,
                  child: Image.memory(
                    _frameImage!,
                    width: 40,
                    height: 80,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                )
            ],
          );
        }),
      ),
    );
  }

  void _flipCamera() {
    if (_cameras == null || _cameras!.length == 1) {
      return;
    }
    int nextIndex = ++_cameraIndex;
    if (nextIndex >= _cameras!.length) {
      nextIndex = 0;
    }
    _cameraIndex = nextIndex;
    _controller?.setDescription(_cameras![nextIndex]);
  }

  void _startImageStream() {
    setState(() {
      _isStremingImage = true;
    });

    if (!kIsWeb) {
      _controller?.startImageStream((CameraImage image) {
        if (!context.mounted) {
          return;
        }
        _bufferCameraImage = image;
      });
    }

    const oneSec = Duration(seconds: 1);
    _progressTimer = Timer.periodic(oneSec, (Timer timer) {
      if (_progress >= kStreamingSecond) {
        _progressTimer?.cancel();
        _frameTimer?.cancel();

        if (!kIsWeb) {
          _controller?.stopImageStream();
        }

        _progressTimer = null;
        _frameTimer = null;

        _isStremingImage = false;
        _frameImage = null;

        Get.off(
          () => ResultView(
            userCondition: UserCondition(
              date: DateTime.now(),
              maxHeartRate: _maxHeartRate,
              minHeartRate: _minHeartRate,
              avgHeartRate: _avgHeartRate,
              stressLevel: _calculateStressIndex(
                _minHeartRate,
                _maxHeartRate,
                _avgHeartRate,
              ),
            ),
          ),
        );
      } else {
        setState(() {
          _progress++;
        });
      }
    });

    _frameTimer = Timer.periodic(
        const Duration(milliseconds: kStreamingFrameDelayMillisecond), (timer) {
      _streamImageToServer(_bufferCameraImage);
    });
  }

  Future<void> _streamImageToServer(CameraImage? cameraImage) async {
    if (cameraImage != null) {
      switch (cameraImage.format.group) {
        case ImageFormatGroup.bgra8888:
          _frameImage = await _convertBGRA8888ToImage(cameraImage);
          break;
        case ImageFormatGroup.yuv420:
          _frameImage = await _convertYUV420toImage(cameraImage);
          break;
        case ImageFormatGroup.nv21:
          _frameImage = await _convertNV21toImage(cameraImage);
          break;
        case ImageFormatGroup.jpeg:
          _frameImage = await _processJPEGImage(cameraImage);
          break;
        case ImageFormatGroup.unknown:
          break;
      }
    }

    _value = Random().nextInt(100);

    if (_minHeartRate == 0 || _minHeartRate > _value) {
      _minHeartRate = _value;
    }
    if (_maxHeartRate == 0 || _maxHeartRate < _value) {
      _maxHeartRate = _value;
    }
    _avgHeartRate = (_avgHeartRate + _value) ~/ 2;

    if (context.mounted) {
      setState(() {});
    }
  }

  Future<Uint8List> _processJPEGImage(CameraImage image) async {
    return Uint8List.fromList(image.planes.first.bytes);
  }

  Future<Uint8List> _convertYUV420toImage(CameraImage cameraImage) async {
    final int width = cameraImage.width;
    final int height = cameraImage.height;
    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    var img = imglib.Image(
      width: width,
      height: height,
    );

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = cameraImage.planes[0].bytes[index];
        final up = cameraImage.planes[1].bytes[uvIndex];
        final vp = cameraImage.planes[2].bytes[uvIndex];

        var r = yp + vp * 1436 / 1024 - 179;
        var g = yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91;
        var b = yp + up * 1814 / 1024 - 227;

        final red = r.clamp(0, 255).toInt();
        final green = g.clamp(0, 255).toInt();
        final blue = b.clamp(0, 255).toInt();
        img.data?.setPixelRgbSafe(x, y, red, green, blue);
      }
    }
    imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);
    final png = pngEncoder.encode(img);
    return png;
  }

  Future<Uint8List> _convertBGRA8888ToImage(CameraImage cameraImage) async {
    final img = imglib.Image.fromBytes(
      width: cameraImage.planes[0].width!,
      height: cameraImage.planes[0].height!,
      bytes: cameraImage.planes[0].bytes.buffer,
      order: imglib.ChannelOrder.bgra,
    );
    imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);
    final png = pngEncoder.encode(img);
    return png;
  }

  Future<Uint8List> _convertNV21toImage(CameraImage image) async {
    final int width = image.width;
    final int height = image.height;
    // YUV -> RGB 변환을 위한 빈 imglib 이미지 생성
    var img = imglib.Image(
      width: width,
      height: height,
    );
    final int uvWidth = width ~/ 2;
    final int uvHeight = height ~/ 2;

    final yPlane = image.planes[0];
    final uvPlane = image.planes[1];
    final yBuffer = yPlane.bytes;
    final uvBuffer = uvPlane.bytes;
    final uvRowStride = uvPlane.bytesPerRow;
    final uvPixelStride = uvPlane.bytesPerPixel!;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
        final yIndex = y * yPlane.bytesPerRow + x;

        final Y = yBuffer[yIndex];
        final V = uvBuffer[uvIndex + 0];
        final U = uvBuffer[uvIndex + 1];

        var r = Y + 1.402 * (V - 128);
        var g = Y - 0.344136 * (U - 128) - 0.714136 * (V - 128);
        var b = Y + 1.772 * (U - 128);

        final red = r.clamp(0, 255).toInt();
        final green = g.clamp(0, 255).toInt();
        final blue = b.clamp(0, 255).toInt();

        img.data?.setPixelRgbSafe(x, y, red, green, blue);
      }
    }

    imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);
    final png = pngEncoder.encode(img);
    return png;
  }

  double _calculateStressIndex(
      int minHeartRate, int maxHeartRate, int avgHeartRate) {
    double stressContributionFromMax = maxHeartRate * 0.1;
    double stressContributionFromAvg = avgHeartRate * 0.05;
    double rawStressIndex =
        stressContributionFromMax + stressContributionFromAvg;
    double normalizedStressIndex = (rawStressIndex / 1000) * 40;
    double stressIndexWithMin = normalizedStressIndex + 15;
    double finalStressIndex = stressIndexWithMin > 40 ? 40 : stressIndexWithMin;
    return double.parse(finalStressIndex.toStringAsFixed(2));
  }
}
