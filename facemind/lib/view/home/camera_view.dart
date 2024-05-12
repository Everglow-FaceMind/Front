import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/global_colors.dart';

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
  CameraController? controller;
  bool isRecording = false;

  // 촬영 진행 상태
  int progress = 0;
  // 측정된 심박수
  int value = 0;

  Timer? timer;
  Uint8List? currentImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    // 카메라 컨트롤러 해제
    controller?.dispose();
    timer?.cancel();
    super.dispose();
  }

  void _initializeCamera() async {
    // 사용 가능한 카메라 가져오기
    final cameras = await availableCameras();

    setState(() {
      _cameras = cameras;
      // 카메라 컨트롤러 초기화
      controller = CameraController(_cameras![1], ResolutionPreset.max,
          enableAudio: false);
      controller!.initialize().then((_) {
        // 카메라가 작동되지 않을 경우

        // 화면이 아직 있는지 확인
        if (!mounted) {
          return;
        }
        // 카메라가 작동될 경우
        setState(() {
          // 코드 작성
        });
      })
          // 카메라 오류 시
          .catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print("CameraController Error : CameraAccessDenied");
              // Handle access errors here.
              break;
            default:
              print("CameraController Error");
              // Handle other errors here.
              break;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 카메라가 준비되지 않으면 아무것도 띄우지 않음
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      appBar: AppBar(
        title: const Text('심박수 측정하기'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.chevron_left, size: 20),
          color: GlobalColors.darkgrayColor,
        ),
        backgroundColor: GlobalColors.whiteColor,
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
                      isRecording
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
                        child: isRecording
                            ? Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: GlobalColors.subBgColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    value.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: GlobalColors.darkgrayColor),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 80,
                                height: 80,
                                child: InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    width: 60,
                                    Assets.flipCameraIcon,
                                  ),
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
                              child: CameraPreview(controller!),
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
                      child: isRecording
                          ? Center(
                              child: SizedBox(
                                height: 40,
                                child: LinearProgressIndicator(
                                  minHeight: 80,
                                  value: progress / 20,
                                  backgroundColor: GlobalColors.lightgrayColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    GlobalColors.mainColor,
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  isRecording = true;
                                });
                                startTimer();
                              },
                              child: Image.asset(
                                width: 60,
                                Assets.cameraIcon,
                              ),
                            ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              if (currentImage != null)
                Align(
                  alignment: Alignment.topRight,
                  child: Image.memory(
                    currentImage!,
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

  bool isProcessTakePicture = false;

  void startTimer() {
    const oneSec = Duration(milliseconds: 500);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (progress >= 20) {
        // 나중에 1분으로 타이머 수정
        timer.cancel();
        setState(() {
          isRecording = false;
          currentImage = null;
          value = 0;
        });

        // Get.off(() => NewDiaryView(
        //       date: DateTime.now(),
        //       // controller: null,
        //       // controller: ,
        //     ));
      } else {
        if (!isProcessTakePicture) {
          isProcessTakePicture = true;
          controller?.takePicture().then((XFile file) async {
            final data = await file.readAsBytes();
            setState(() {
              currentImage = data;
            });
            sendImageToServer(data);
            print(data.length);
            isProcessTakePicture = false;
          });
        }

        setState(() {
          progress++;
        });
      }
    });
  }

  Future<void> sendImageToServer(Uint8List data) async {
    // 서버로 이미지 전송하는 부분
    // 서버에 이미지 전송 후 value를 업데이트 하여 유아이 표시
    setState(() {
      value = Random().nextInt(100);
    });
  }
}
