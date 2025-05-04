import 'package:truncate/truncate.dart';

RegExp exp = RegExp(r"<[^>]*>",multiLine: true,caseSensitive: true);

String parseString(String text, {int? maxLength}){
  String parsedText = text.replaceAll(exp, '');
  if(maxLength != null){
    parsedText = truncate(parsedText, maxLength, omission: '...');
  }
  return parsedText;
}