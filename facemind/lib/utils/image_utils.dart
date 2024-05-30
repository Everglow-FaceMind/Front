import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;

// ImageUtils 클래스
class ImageUtils {
  // CameraImage 객체를 YUV420 형식에서 imageLib.Image(RGB 형식)으로 변환
  static imglib.Image? convertCameraImage(CameraImage cameraImage) {
    switch (cameraImage.format.group) {
      case ImageFormatGroup.bgra8888:
        return _convertBGRA8888ToImage(cameraImage);
      case ImageFormatGroup.yuv420:
        return _convertYUV420toImage(cameraImage);
      case ImageFormatGroup.nv21:
        return _convertNV21toImage(cameraImage);
      default:
        return null;
    }
  }

  static Uint8List? convertImageToJpeg(imglib.Image? image) {
    if (image == null) return null;
    imglib.JpegEncoder jpegEncoder = imglib.JpegEncoder();
    final png = jpegEncoder.encode(image);
    return Uint8List.fromList(png);
  }

  static imglib.Image _convertYUV420toImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;
    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    // imglib 라이브러리를 사용하여 이미지를 생성
    var img = imglib.Image(
      width: width,
      height: height,
    ); // Create Image buffer

    // YUV420 데이터를 이미지 버퍼에 채움
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = cameraImage.planes[0].bytes[index];
        final up = cameraImage.planes[1].bytes[uvIndex];
        final vp = cameraImage.planes[2].bytes[uvIndex];
        // YUV -> RGB 변환
        var r = yp + vp * 1436 / 1024 - 179;
        var g = yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91;
        var b = yp + up * 1814 / 1024 - 227;
        // 색상 값을 0에서 255 사이로 조정
        final red = r.clamp(0, 255).toInt();
        final green = g.clamp(0, 255).toInt();
        final blue = b.clamp(0, 255).toInt();
        // imglib에 RGB 값을 넣어 이미지를 완성
        img.data?.setPixelRgbSafe(x, y, red, green, blue);
      }
    }
    return img;
  }

  static imglib.Image _convertBGRA8888ToImage(CameraImage cameraImage) {
    final img = imglib.Image.fromBytes(
      width: cameraImage.planes[0].width!,
      height: cameraImage.planes[0].height!,
      bytes: cameraImage.planes[0].bytes.buffer,
      order: imglib.ChannelOrder.bgra,
    );
    return img;
  }

  static imglib.Image _convertNV21toImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    // YUV -> RGB 변환을 위한 빈 imglib 이미지 생성
    var img = imglib.Image(
      width: width,
      height: height,
    ); // Create Image buffer

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
        final V = uvBuffer[uvIndex + 0]; // V and U are swapped in NV21
        final U = uvBuffer[uvIndex + 1];

        var r = Y + 1.402 * (V - 128);
        var g = Y - 0.344136 * (U - 128) - 0.714136 * (V - 128);
        var b = Y + 1.772 * (U - 128);

        // Color value clipping
        final red = r.clamp(0, 255).toInt();
        final green = g.clamp(0, 255).toInt();
        final blue = b.clamp(0, 255).toInt();

        // Set pixel color
        img.data?.setPixelRgbSafe(x, y, red, green, blue);
      }
    }

    return img;
  }
}
