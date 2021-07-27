import 'package:flutter/material.dart';
import 'package:ivugurura_app/widget/shimmer.dart';

class ShimmerLoading extends StatelessWidget{
  final Widget child;

  ShimmerLoading({Key? key, required this.child}):super(key: key);

  @override
  Widget build(BuildContext context) {
    final shimmer = Shimmer.of(context)!;

    if(!shimmer.isSized){
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final offsetWithinShimmer = shimmer.getDescendantOffset(
        renderBox: context.findRenderObject() as RenderBox
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds){
        return gradient.createShader(
          Rect.fromLTWH(
              -offsetWithinShimmer.dx,
              -offsetWithinShimmer.dy,
              shimmerSize.width,
              shimmerSize.height
          )
        );
      },
      child: child,
    );
  }
}