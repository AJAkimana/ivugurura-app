import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeQuote extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Icon(
              FontAwesomeIcons.quoteLeft,
              size: 30.0,
              color: Colors.grey,
            ),
          ),
          Animator(
            triggerOnInit: true,
            curve: Curves.easeIn,
            duration: Duration(microseconds: 500),
            tween: Tween<double>(begin: -1, end: 0),
            builder: (context, state, child){
              return FractionalTranslation(
                translation: Offset(state.value as double, 0),
                child: child,
              );
            },
            child: Text(
              translate('lesson.mathew24_14_book'),
              style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Colors.grey.shade800
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Animator(
            triggerOnInit: true,
            tween: Tween<double>(begin: 1, end: 0),
            builder: (context, state, child){
              return FractionalTranslation(
                translation: Offset(state.value as double, 0),
                child: child,
              );
            },
            child: Text(
              translate('lesson.mathew24_14'),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: Colors.grey.shade600,
                fontSize: 20.0
              ),
            ),
          )
        ],
      ),
    );
  }
}