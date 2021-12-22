import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
        title: translate('app.no_connection'),
        message: translate('app.no_conn_msg'),
        assetName: 'assets/frustrated-face.png',
        onTryAgain: onTryAgain,
      );
    }
    return ErrorIndicator(
      title: translate('app.error_title'),
      message: translate('app.error_description'),
      assetName: 'assets/confused-face.png',
      onTryAgain: onTryAgain,
    );
  }
}
