import 'package:flutter/material.dart';

enum AlertDialogType {
  SUCCESS,
  ERROR,
  WARNING,
  INFO
}

class CustomAlertDialog extends StatelessWidget {
  final AlertDialogType type;
  final String title, content, btnLabel;
  final Widget? icon;
  final Widget? translateTexts;
  final Widget widget;
  final Function()? onPressOk;
  final TextStyle titleStyle = TextStyle(
    fontSize: 20.0,
    color: Colors.black,
      fontWeight: FontWeight.bold
  );

  CustomAlertDialog({
    Key? key,
    this.title = "Successful",
    required this.content,
    this.icon,
    this.translateTexts,
    required this.widget,
    this.onPressOk,
    this.type = AlertDialogType.INFO,
    this.btnLabel = "Ok"
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10.0),
              icon ?? Icon(
                _getIconForType(type),
                color: _getColorForType(type),
                size: 50,
              ),
              const SizedBox(height: 10.0),
              Text(title, style: titleStyle, textAlign: TextAlign.center),
              Text('Hitamo ururimi', style: titleStyle, textAlign: TextAlign.center),
              Text('Chagua lugha', style: titleStyle, textAlign: TextAlign.center),
              Divider(),
              Container(
                alignment: Alignment.center,
                child: this.widget,
              ),
              // Text(content, textAlign: TextAlign.center),
              if(onPressOk!=null) ...[
                SizedBox(height: 40.0),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    child: Text(btnLabel),
                    onPressed: this.onPressOk,
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

Color _getColorForType(AlertDialogType type){
  switch(type){
    case AlertDialogType.WARNING:
      return Colors.orange;
    case AlertDialogType.SUCCESS:
      return Colors.green;
    case AlertDialogType.ERROR:
      return Colors.red;
    case AlertDialogType.INFO:
    default:
      return Colors.blue;
  }
}

IconData _getIconForType(AlertDialogType type){
  switch(type){
    case AlertDialogType.WARNING:
      return Icons.warning;
    case AlertDialogType.SUCCESS:
      return Icons.check_circle;
    case AlertDialogType.ERROR:
      return Icons.error;
    case AlertDialogType.INFO:
    default:
      return Icons.info_outline;
  }
}
