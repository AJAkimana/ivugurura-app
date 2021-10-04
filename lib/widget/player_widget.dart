import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/notifications.dart';
import 'package:ivugurura_app/core/models/audio.dart';

class PlayerWidget extends StatefulWidget {
  final Audio audio;
  final PlayerMode playerMode;
  final bool isRadio;

  const PlayerWidget(
      {Key? key,
      required this.audio,
      this.playerMode = PlayerMode.MEDIA_PLAYER,
      this.isRadio = true})
      : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState(audio, playerMode);
}

class _PlayerWidgetState extends State<PlayerWidget> {
  Audio audio;
  PlayerMode playerMode;

  late AudioPlayer _audioPlayer;
  PlayerState? _audioPlayerState;
  Duration? _duration;
  Duration? _position;

  PlayerState _playerState = PlayerState.COMPLETED;
  PlayingRoute _playingRoute = PlayingRoute.SPEAKERS;
  StreamSubscription? _durationStreamSubstription;
  StreamSubscription? _positionStreamSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerErrorSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription<PlayerControlCommand>? _playerCommandSubscription;

  bool get _isPlaying => _playerState == PlayerState.PLAYING;
  bool get _isPaused => _playerState == PlayerState.PAUSED;
  String get durationText => _duration?.toString().split('.').first ?? '...';
  String get positionText => _position?.toString().split('.').first ?? '...';
  bool get isPlayingThroughEarpiece => _playingRoute == PlayingRoute.EARPIECE;

  _PlayerWidgetState(this.audio, this.playerMode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationStreamSubstription?.cancel();
    _positionStreamSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerCommandSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(positionText, style: TextStyle(fontSize: 16)),
                Text(durationText, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          _slider(),
          _buildActionButtons(),
          Text('State: $_audioPlayerState'),
        ],
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: playerMode);
    _durationStreamSubstription = _audioPlayer.onDurationChanged.listen((dur) {
      setState(() => _duration = dur);
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        _audioPlayer.notificationService.startHeadlessService();
        _audioPlayer.notificationService.setNotification(
            title: 'Ivugurura n Ubugorozi',
            artist: audio.author!,
            albumTitle: audio.type!,
            imageUrl: 'Image',
            forwardSkipInterval: const Duration(seconds: 30),
            backwardSkipInterval: const Duration(seconds: 30),
            duration: dur,
            enableNextTrackButton: true,
            enablePreviousTrackButton: true);
      }
    });

    _positionStreamSubscription =
        _audioPlayer.onAudioPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
      });
    });
    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      _position = _duration;
    });
    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((event) {
      setState(() {
        _playerState = PlayerState.STOPPED;
        _duration = const Duration();
        _position = const Duration();
      });
    });
    _playerCommandSubscription =
        _audioPlayer.notificationService.onPlayerCommand.listen((command) {
      print('Command: $command');
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _audioPlayerState = state;
        });
      }
    });
    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (mounted) {
        _audioPlayerState = state;
      }
    });
    _playingRoute = PlayingRoute.SPEAKERS;
    _play(fromStart: true);
  }

  Future<int> _play({bool fromStart=false}) async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position!.inMilliseconds > 0 &&
            _position!.inMilliseconds < _duration!.inMilliseconds)
        ? _position
        : null;
    final startPosition = fromStart?null:playPosition;
    final result =
        await _audioPlayer.play(audio.mediaLink!, position: startPosition);
    if (result == 1) {
      setState(() => _playerState = PlayerState.PLAYING);
    }
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() => _playerState = PlayerState.PAUSED);
    }
    return result;
  }

  Future<int> _earPieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1) {
      setState(() => _playingRoute = _playingRoute.toggle());
    }
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.STOPPED;
        _position = const Duration();
      });
    }
    return result;
  }

  _onComplete() {
    setState(() => _playerState = PlayerState.STOPPED);
  }

  Widget _slider() {
    return Slider(
      activeColor: Colors.red,
      inactiveColor: Colors.grey,
      value: _position != null ? _position!.inSeconds.toDouble() : 0,
      min: 0.0,
      max: (_duration != null &&
              _position != null &&
              _position!.inMilliseconds <= _duration!.inMilliseconds)
          ? _duration!.inSeconds.toDouble()
          : 100,
      onChanged: (double value) {
        setState(() {
          Duration newDuration = Duration(seconds: value.toInt());
          _audioPlayer.seek(newDuration);
        });
      },
    );
  }

  Widget _buildActionButtons() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            key: Key('previous_button'),
            padding: const EdgeInsets.only(bottom: 10),
            icon: Icon(Icons.skip_previous, size: 20, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            key: Key('play_button'),
            padding: const EdgeInsets.only(bottom: 10),
            onPressed: _isPlaying ? _pause : _play,
            icon: _isPlaying
                ? Icon(Icons.pause, size: 50, color: Colors.blue)
                : Icon(Icons.play_circle_fill, size: 50, color: Colors.blue),
          ),
          IconButton(
            key: Key('next_button'),
            padding: const EdgeInsets.only(bottom: 10),
            icon: Icon(Icons.skip_next, size: 20, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
