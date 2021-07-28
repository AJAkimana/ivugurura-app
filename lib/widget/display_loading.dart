// Copyright 2021, Akimana Jean d Amour
import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/rounded_container.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class DisplayLoading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      borderRadius: BorderRadius.circular(1.0),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(1.0),
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(2),
          child: SkeletonGridLoader(
            builder: Card(
              color: Colors.transparent,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(width: 50, height: 10, color: Colors.white),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 2,
                    child: Container(width: 70, height: 210, color: Colors.white),
                  )
                ],
              ),
              // child: GridTile(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Container(width: 50, height: 10, color: Colors.white),
              //       SizedBox(height: 10,),
              //       Container(width: 70, height: 10, color: Colors.white),
              //     ],
              //   ),
              // ),
            ),
            items: 1,
            itemsPerRow: 1,
            period: Duration(seconds: 2),
            highlightColor: Colors.lightBlue[300]!,
            direction: SkeletonDirection.ltr,
            childAspectRatio: 1,
          ),
        ),
      )
    );
  }
}