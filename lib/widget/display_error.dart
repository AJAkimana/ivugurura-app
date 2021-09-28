import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/rounded_container.dart';
import 'package:ivugurura_app/widget/error_indicator.dart';

class DisplayError extends StatelessWidget {
  final dynamic error;
  final VoidCallback? onTryAgain;
  const DisplayError({
    Key? key,
    required this.error,
    this.onTryAgain
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(error is SocketException){
      return ErrorIndicator(
        title: 'No connection',
        message: 'Please check the internet connection and try again',
        assetName: 'assets/frustrated-face.png',
        onTryAgain: onTryAgain,
      );
    }
    return ErrorIndicator(
      title: 'Something went wrong',
      message: 'The application has encountered an unknown error.\nPlease try again later',
      assetName: 'assets/confused-face.png',
      onTryAgain: onTryAgain,
    );
  }
}
