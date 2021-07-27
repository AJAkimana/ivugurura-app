import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/rounded_container.dart';

class DisplayError extends StatelessWidget {
  final String title;
  const DisplayError({
    this.title = 'Sorry, an error happened',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
        borderRadius: BorderRadius.circular(4.0),
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
              )
            ]
        )
    );
  }
}
