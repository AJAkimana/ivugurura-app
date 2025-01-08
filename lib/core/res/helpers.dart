import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/res/app_colors.dart';

BoxDecoration gradientBoxDecoration({
  Alignment begin = Alignment.topLeft,
  Alignment end = Alignment.bottomRight,
  List<Color> colors = const [Color(0xFF3A6073), Color(0xFF16222A)],
}) {
  return BoxDecoration(
      gradient: LinearGradient(
          colors: [AppColors.decoratorColor1, AppColors.decoratorColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
      )
  );
}