import 'package:flutter/material.dart';
import 'package:ivugurura_app/widget/sliding_gradiant_transform.dart';

class Shimmer extends StatefulWidget{
  static ShimmerState? of(BuildContext context){
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({Key? key, required this.linearGradient, this.child}): super(key: key);

  final LinearGradient linearGradient;
  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin{
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
    ..repeat(min: -0.5, max: 1.5, period: const Duration(microseconds: 1000));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  LinearGradient get gradient => LinearGradient(
    colors: widget.linearGradient.colors,
    stops: widget.linearGradient.stops,
    begin: widget.linearGradient.begin,
    end: widget.linearGradient.end,
    transform: SlidingGradientTransform(sliderPercent: _shimmerController.value),
  );

  bool get isSized => (context.findRenderObject() as RenderBox).hasSize;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox renderBox,
    Offset offset = Offset.zero,
  }){
    final shimmerBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(offset, ancestor: shimmerBox);
  }

  Listenable get shimmerChanges => _shimmerController;

  @override
  Widget build(BuildContext context) {
    return widget.child?? const SizedBox();
  }
}