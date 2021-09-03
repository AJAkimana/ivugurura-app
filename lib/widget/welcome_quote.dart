import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
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
              'Anyone who has never made a mistake has never tried anything new',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                color: Colors.grey.shade800
              ),
            ),
          ),
          const SizedBox(height: 10.0),
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
              'Albert Einstein',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
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