import 'package:camera/camera.dart';
import 'package:get/state_manager.dart';

class ScanController extends GetxController {
  final RxBool _isInitialized = RxBool(false);
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;

  bool get isInitialized => _isInitialized.value;

  CameraController get cameraController => _cameraController;

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      print("cameras : $_cameras");
      _cameraController = CameraController(_cameras[1], ResolutionPreset.max,
          enableAudio: false);
      _cameraController.initialize().then((_) async {
        // onLatestImageAvailable 함수를 전달하여 각 프레임에 대한 인식을 수행
        await cameraController.startImageStream(onLatestImageAvailable);
      });
      _isInitialized.value = true; // 카메라가 초기화되었음을 표시
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    }
  }

  // 프레임마다 호출
  onLatestImageAvailable(CameraImage cameraImage) async {}

  @override
  void onInit() {
    _initCamera();
    super.onInit();
  }

  @override
  void onClose() {
    _cameraController.dispose(); // 리소스를 정리
    super.onClose();
  }
}
