import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:ivugurura_app/core/custom_pagination_builder.dart';
import 'package:ivugurura_app/core/utils/constants.dart';

class OnBoardingPage extends StatefulWidget{
  
  @override
  _OnBoardingPageState createState()=> _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>{
  final SwiperController swiperController = SwiperController();
  final int pageCount = 3;
  int currentIndex = 0;
  final List<String> titles = [
    'The first text', 'The second text', 'The third text'
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Swiper(
              index:  currentIndex,
              controller: swiperController,
              itemCount: pageCount,
              onIndexChanged: (index){
                setState(() {
                  currentIndex = index;
                });
              },
              loop: false,
              itemBuilder: (context, index){
                return _buildPage(title: titles[index]);
              },
              pagination: SwiperPagination(
                builder: CustomPaginationBuilder(
                  activeColor: Colors.white,
                  activeSize: Size(10.0, 20.0),
                  size: Size(10.0, 20.0),
                  color: Colors.grey.shade600
                )
              ),
            ),
          ),
          SizedBox(height: 10.0,)
        ],
      ),
    );
  }
  
  Widget _buildPage({required String title}){
    final TextStyle textStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 40.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: textStyle.copyWith(color: Colors.white),
          ),
          SizedBox(height: 30)
        ],
      ),
    );
  }
}