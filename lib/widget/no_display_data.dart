import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/rounded_container.dart';

class NoDisplayData extends StatelessWidget {
  final String title;
  const NoDisplayData({
    this.title = 'No data to display',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4
      ),
    );
  }
}
