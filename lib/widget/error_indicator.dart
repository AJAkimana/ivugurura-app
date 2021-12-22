import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ErrorIndicator extends StatelessWidget {
  final String title, assetName;
  final String? message;
  final VoidCallback? onTryAgain;

  const ErrorIndicator(
      {Key? key,
      required this.title,
      required this.assetName,
      this.message,
      this.onTryAgain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btnMsg = translate('app.try_btn');
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: <Widget>[
            // Image.asset(assetName),
            const SizedBox(height: 32),
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!, textAlign: TextAlign.center)
            ],
            if (onTryAgain != null) ...[
              const Spacer(),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: onTryAgain,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: Text(btnMsg,
                        style: TextStyle(fontSize: 16, color: Colors.white))),
              )
            ]
          ],
        ),
      ),
    );
  }
}
