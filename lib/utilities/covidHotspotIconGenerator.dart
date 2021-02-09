import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> generateCovidHotspotIcon(double markerSize) async {
  final pictureRecorder = PictureRecorder();
  final canvas = Canvas(pictureRecorder);
  final textPainter = TextPainter(textDirection: TextDirection.ltr);
  final iconString = String.fromCharCode(Icons.coronavirus.codePoint);

  final circleStrokeWidth = markerSize / 10.0;
  final circleOffset = markerSize / 2;
  final fillCircleWidth = markerSize / 2;
  final outlineCircleInnerWidth = markerSize - (2 * circleStrokeWidth);
  final iconSize = sqrt(pow(outlineCircleInnerWidth, 2) / 2);
  final rectDiagonal = sqrt(2 * pow(markerSize, 2));
  final circleDistanceToCorners = (rectDiagonal - outlineCircleInnerWidth) / 2;
  final iconOffset = sqrt(pow(circleDistanceToCorners, 2) / 2);

  final Paint paintCircle = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.orange.withOpacity(0.5);

  canvas.drawCircle(Offset(circleOffset, circleOffset), fillCircleWidth, paintCircle);

  textPainter.text = TextSpan(
    text: iconString,
    style: TextStyle(
      letterSpacing: 0.0,
      fontSize: iconSize,
      fontFamily: Icons.coronavirus.fontFamily,
      color: Colors.black
    )
  );
  textPainter.layout();
  textPainter.paint(canvas, Offset(iconOffset, iconOffset));

  final picture = pictureRecorder.endRecording();
  final image = await picture.toImage(markerSize.round(), markerSize.round());
  final bytes = await image.toByteData(format: ImageByteFormat.png);
  final bitmapDescriptor = BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  return bitmapDescriptor;
}