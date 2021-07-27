// Copyright 2021, Akimana Jean d Amour
import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/rounded_container.dart';
import 'package:ivugurura_app/widget/shimmer.dart';
import 'package:ivugurura_app/widget/shimmer_loading.dart';
import 'package:ivugurura_app/widget/utils.dart';

class DisplayLoading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer(
        linearGradient: shimmerGradient,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
              ShimmerLoading(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedContainer(
                    borderRadius: BorderRadius.circular(4.0),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 250,
                                height: 24,
                                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
                              ),
                              const SizedBox(height: 16),
                              // Container(
                              //   width: 230,
                              //   height: 24,
                              //   decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.blueAccent,
                            // child: Image.asset('assets/reformation.jpg', fit: BoxFit.cover, height: 210),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
                              // height: 210,
                              width: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}