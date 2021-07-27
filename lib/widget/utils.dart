import 'package:flutter/material.dart';

const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [0.1, 0.2, 0.3],
  begin: Alignment(-1.0, -3.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);