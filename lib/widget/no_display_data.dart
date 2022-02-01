import 'package:flutter/material.dart';
import 'package:ivugurura_app/widget/error_indicator.dart';

class NoDisplayData extends StatelessWidget {
  final String title;
  final String message;
  const NoDisplayData({
    this.title = 'No data to display',
    this.message = 'We couldn\'t find any results',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorIndicator(
      title: title,
      message: message,
      assetName: 'assets/empty-box.png'
    );
  }
}
