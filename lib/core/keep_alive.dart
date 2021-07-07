import 'package:flutter/material.dart';

class AlwaysAliveWidget extends StatefulWidget{
  final Widget child;

  const AlwaysAliveWidget({
    Key? key,
    required this.child
  }):super(key: key);

  @override
  _AlwaysAliveWidgetState createState() => _AlwaysAliveWidgetState();
}

class _AlwaysAliveWidgetState extends State<AlwaysAliveWidget>
    with AutomaticKeepAliveClientMixin<AlwaysAliveWidget>{

  @override
  Widget build(BuildContext context) {
    return super.widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
