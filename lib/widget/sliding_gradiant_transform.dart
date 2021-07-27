import 'package:flutter/material.dart';

class SlidingGradientTransform extends GradientTransform{
  final double sliderPercent;

  const SlidingGradientTransform({required this.sliderPercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * sliderPercent, 0.0, 0.0);
  }
}