import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/global_colors.dart';

class Assets {
  static String userIcon = 'assets/icon/icon_user.png';
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
  late List<CameraDescription> _cameras = [];
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    // 사용 가능한 카메라 가져오기
    final cameras = await availableCameras();

    setState(() {
      _cameras = cameras;
      // 카메라 컨트롤러 초기화
      controller = CameraController(_cameras[0], ResolutionPreset.max,
          enableAudio: false);
      controller.initialize().then((_) {
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

  // 사진을 찍는 함수
  // Future<void> _takePicture() async {
  //   if (!controller.value.isInitialized) {
  //     return;
  //   }

  //   try {
  //     // 사진 촬영
  //     final XFile file = await controller.takePicture();

  //     // import 'dart:io';
  //     // 사진을 저장할 경로 : 기본경로(storage/emulated/0/)
  //     Directory directory = Directory('storage/emulated/0/DCIM/MyImages');

  //     // 지정한 경로에 디렉토리를 생성하는 코드
  //     // .create : 디렉토리 생성    recursive : true - 존재하지 않는 디렉토리일 경우 자동 생성
  //     await Directory(directory.path).create(recursive: true);

  //     // 지정한 경로에 사진 저장
  //     await File(file.path).copy('${directory.path}/${file.name}');
  //   } catch (e) {
  //     print('Error taking picture: $e');
  //   }
  // }

  Future<void> _recordVideo() async {
    await controller.startVideoRecording(); //녹화 방식 가정
    Future.delayed(const Duration(seconds: 30)).then((value) async {
      final file = await controller.stopVideoRecording();
      _sendToServer(file);
    });
  }

  Future<void> _sendToServer(XFile file) async {
    // TODO: 서버로 파일 전송
    Get.snackbar('서버에 전송', '영상을 서버에 전송 완료');
  }

// recording 영상 촬영
// await controller.startVideoRecording()
// await controller.stopVideoRecording()
// await controller.resumeVideoRecording()

  @override
  void dispose() {
    // 카메라 컨트롤러 해제
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 카메라가 준비되지 않으면 아무것도 띄우지 않음
    if (!controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.chevron_left, size: 20),
          color: GlobalColors.darkgrayColor,
        ),
        backgroundColor: GlobalColors.whiteColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 좌우 정렬
          children: [
            const SizedBox(height: 70),
            const Text(
              '얼굴을 가이드 선 영역에 맞추고\n촬영 버튼을 눌러 주세요!',
              textAlign: TextAlign.center, // 텍스트 중앙 정렬
              style: TextStyle(
                fontSize: 13,
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.cameraswitch_outlined),
              ),
            ),
            // constraints을 통하여 현재 그릴 수 있는 최대 영역 값을 구할 수 있다.
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final maxHeight = constraints.maxHeight;
                final maxWidth = constraints.maxWidth;

                final previewWidth = maxWidth - 100;
                final previewHeight = previewWidth * 1.5;

                return SizedBox(
                  width: previewWidth,
                  height: previewHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        // 카메라 촬영 화면이 보일 CameraPrivew
                        child: CameraPreview(controller),
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
                );
              },
            ),
            IconButton(
              onPressed: () {
                _recordVideo();
              },
              icon: const Icon(Icons.camera),
            ),
          ],
        ),
      ),
    );

    // return Stack(
    //   //backgroundColor: GlobalColors.whiteColor,
    //   children: [
    //     // 화면 전체를 차지하도록 Positioned.fill 위젯 사용
    //     Positioned.fill(
    //       // 카메라 촬영 화면이 보일 CameraPrivew
    //       child: CameraPreview(controller),
    //     ),
    //     // 하단 중앙에 위치도록 Align 위젯 설정
    //     Align(
    //       alignment: Alignment.bottomCenter,
    //       child: Padding(
    //         padding: const EdgeInsets.all(15.0),
    //         // 버튼 클릭 이벤트 정의를 위한 GestureDetector
    //         child: GestureDetector(
    //           onTap: () {
    //             // 사진 찍기 함수 호출
    //             _recordVideo();
    //           },
    //           // 버튼으로 표시될 Icon
    //           child: const Icon(
    //             Icons.camera_enhance,
    //             size: 70,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}

// return Scaffold(
//       backgroundColor: GlobalColors.whiteColor,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.chevron_left, size: 20),
//           color: GlobalColors.darkgrayColor,
//         ),
//         title: Text(
//           '심박수 측정하기',
//           style: TextStyle(
//               color: GlobalColors.darkgrayColor,
//               fontSize: 15,
//               fontWeight: FontWeight.w500),
//           textAlign: TextAlign.left,
//         ),
//         backgroundColor: GlobalColors.whiteColor,
//       ),
//       body: const Center(
//           child: Column(
//         children: [
//           const SizedBox(height: 70),
//           const Text(
//             '얼굴을 가이드 선 영역에 맞추고\n촬영 버튼을 눌러 주세요!',
//             style: TextStyle(
//               fontSize: 13,
//             ),
//           ),
//           const Text(
//             '촬영 버튼을 눌러 주세요!',
//             style: TextStyle(
//               fontSize: 13,
//             ),
//           ),]
//           )
//       )
// )
