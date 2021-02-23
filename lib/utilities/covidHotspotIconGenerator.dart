import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CovidHotspotIconGenerator {
  static Uint8List _covidHotspotIconByteData;

  static Future<BitmapDescriptor> getCovidHotpostIcon(int size) async {
    if (_covidHotspotIconByteData == null) {
      _covidHotspotIconByteData = await _generateCovidHotspotIcon();
    }
    final Codec covidHotspotIconCodec = await instantiateImageCodec(
        _covidHotspotIconByteData,
        targetWidth: size,
        targetHeight: size);
    final FrameInfo frameInfo = await covidHotspotIconCodec.getNextFrame();
    final ByteData byteData = await frameInfo.image.toByteData(format: ImageByteFormat.png);
    final Uint8List resizedCovidHotspotIconByteData = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedCovidHotspotIconByteData);
  }

  static Future<Uint8List> _generateCovidHotspotIcon() async {
    const markerSize = 200;
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final iconString = String.fromCharCode(Icons.coronavirus.codePoint);

    const circleStrokeWidth = markerSize / 10.0;
    const circleOffset = markerSize / 2;
    const fillCircleWidth = markerSize / 2;
    const outlineCircleInnerWidth = markerSize - (2 * circleStrokeWidth);
    final iconSize = sqrt(pow(outlineCircleInnerWidth, 2) / 2);
    final rectDiagonal = sqrt(2 * pow(markerSize, 2));
    final circleDistanceToCorners =
        (rectDiagonal - outlineCircleInnerWidth) / 2;
    final iconOffset = sqrt(pow(circleDistanceToCorners, 2) / 2);

    final Paint paintCircle = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.orange.withOpacity(0.5);

    canvas.drawCircle(
        const Offset(circleOffset, circleOffset), fillCircleWidth, paintCircle);

    textPainter.text = TextSpan(
        text: iconString,
        style: TextStyle(
            letterSpacing: 0.0,
            fontSize: iconSize,
            fontFamily: Icons.coronavirus.fontFamily,
            color: Colors.black));
    textPainter.layout();
    textPainter.paint(canvas, Offset(iconOffset, iconOffset));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(markerSize.round(), markerSize.round());
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }
}
