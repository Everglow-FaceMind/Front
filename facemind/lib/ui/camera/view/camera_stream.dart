import 'dart:async';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:camera/camera.dart';
import 'package:facemind/ui/home/result_view.dart';
import 'package:facemind/ui/common/widgets/appbar.dart';
import 'package:facemind/utils/frame_utils.dart';
import 'package:facemind/utils/image_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as imglib;

import '../../../model/user_condition.dart';
import '../../../utils/global_colors.dart';
import '../../../utils/socket/socket_io_repository.dart';

/// 촬영 시간, 60초로 수정
const int kStreamingSecond = 10;

/// 웹에서 프레임 딜레이
const int kWebFrameDelay = 10;

class Assets {
  static String userIcon = 'assets/icon/icon_user.png';
  static String cameraIcon = 'assets/icon/camera.png';
  static String flipCameraIcon = 'assets/icon/flip_camera.png';
}

class CameraStream extends StatefulWidget {
  const CameraStream({
    super.key,
  });
  @override
  State<StatefulWidget> createState() => _CameraStreamState();
}

class _CameraStreamState extends State<CameraStream> {
  late final FrameUtil _frameUtil = FrameUtil(
    frameBufferLength: 1000,
    onFrameBufferFull: (value) {
      final list = value.map((e) => e.buffer.asUint8List()).toList();
      SocketClient.to.send('image', list);
    },
  );

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
  Timer? _webFrameTimer;

  Uint8List? _frameDisplayImage;

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
    _webFrameTimer?.cancel();
    super.dispose();
  }

  void _initializeCamera() async {
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
        ResolutionPreset.low,
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
              debugPrint("CameraController Error : CameraAccessDenied");
              break;
            default:
              debugPrint("CameraController Error");
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
              if (_frameDisplayImage != null)
                Align(
                  alignment: Alignment.topRight,
                  child: Image.memory(
                    _frameDisplayImage!,
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
        _processImage(image);
      });
    } else {
      _webFrameTimer = Timer.periodic(
          const Duration(milliseconds: kWebFrameDelay), (timer) async {
        if (!context.mounted) {
          return;
        }
        final file = await _controller?.takePicture();
        _processImageForWeb(file);
      });
    }

    const oneSec = Duration(seconds: 1);
    _progressTimer = Timer.periodic(oneSec, (Timer timer) {
      if (_progress >= kStreamingSecond) {
        _progressTimer?.cancel();
        if (!kIsWeb) {
          _controller?.stopImageStream();
        }
        _progressTimer = null;

        _isStremingImage = false;
        _frameDisplayImage = null;

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
  }

  Future<void> _processImageForWeb(XFile? file) async {
    if (file == null) {
      return;
    }
    final bytes = await file.readAsBytes();
    debugPrint('image bytes length: ${bytes.length}');
    debugPrint(DateTime.now().toString());

    final frame = imglib.decodeImage(bytes);
    if (frame != null) {
      // Compress the frame
      final compressedFrame = await FlutterImageCompress.compressWithList(
        frame.getBytes(),
        quality: 50,
      );
      _frameUtil
          .addFrame(imglib.decodeImage(Uint8List.fromList(compressedFrame))!);
      setState(() {
        _frameDisplayImage = ImageUtils.convertImageToJpeg(
            imglib.decodeImage(Uint8List.fromList(compressedFrame))!);
      });
    }
  }

  Future<void> _processImage(CameraImage? cameraImage) async {
    // UI TEST Code
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

    if (cameraImage != null) {
      final frame = ImageUtils.convertCameraImage(cameraImage);
      if (frame != null) {
        // Compress the frame
        final compressedFrame = await FlutterImageCompress.compressWithList(
          frame.getBytes(),
          quality: 50,
        );
        _frameUtil
            .addFrame(imglib.decodeImage(Uint8List.fromList(compressedFrame))!);
        setState(() {
          _frameDisplayImage = ImageUtils.convertImageToJpeg(
              imglib.decodeImage(Uint8List.fromList(compressedFrame))!);
        });
      }
    }
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
