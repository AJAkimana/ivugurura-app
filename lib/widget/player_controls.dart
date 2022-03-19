import 'package:flutter/material.dart';

class PlayControls extends StatefulWidget {
  final bool isPlaying;
  final bool prevEnableFeedback;
  final bool nextEnableFeedback;
  final double width;
  final VoidCallback onSetNext, onSetPrev, onSetPlay;
  PlayControls({
    Key? key,
      this.isPlaying = false,
      this.prevEnableFeedback = false,
      this.nextEnableFeedback = false,
      required this.onSetNext,
      required this.onSetPrev,
      required this.onSetPlay,
    this.width = 0.7
  })
      : super(key: key);

  @override
  _PlayControls createState() => _PlayControls();
}

class _PlayControls extends State<PlayControls> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          height: 35,
          width: MediaQuery.of(context).size.width * widget.width,
          margin: EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 5)],
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                ),
                enableFeedback: widget.prevEnableFeedback,
                onPressed: widget.onSetPrev,
              ),
              IconButton(
                icon: Icon(
                  widget.isPlaying ? Icons.play_circle : Icons.pause,
                  color: Colors.white,
                ),
                onPressed: widget.onSetPlay,
              ),
              IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ),
                enableFeedback: widget.nextEnableFeedback,
                onPressed: widget.onSetNext,
              ),
            ],
          ),
        )
      ],
    );
  }
}
