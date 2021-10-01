import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/notifications.dart';
import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/models/audio.dart';

class PlayerWidget extends StatefulWidget{
  final Audio audio;
  final PlayerMode playerMode;

  const PlayerWidget({
    Key? key,
    required this.audio,
    this.playerMode = PlayerMode.MEDIA_PLAYER
  }):super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState(audio, playerMode);
}

class _PlayerWidgetState extends State<PlayerWidget>{
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

  bool get _isPausing => _playerState == PlayerState.PLAYING;
  bool get _isPaused => _playerState == PlayerState.PAUSED;
  String get durationText => _duration.toString().split('.').first??'...';
  String get positionText => _position.toString().split('.').first??'...';
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

  void _initAudioPlayer(){
    _audioPlayer = AudioPlayer(mode: playerMode);
    _durationStreamSubstription = _audioPlayer.onDurationChanged.listen((dur) {
      setState(()=>_duration = dur);
      if(Theme.of(context).platform == Platform.isIOS){
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
          enablePreviousTrackButton: true
        );
      }
    });

    _positionStreamSubscription = _audioPlayer.onAudioPositionChanged.listen((pos) {
      _position = pos;
    });
    _playerCompleteSubscription = _audioPlayer.onPlayerCompletion.listen((event) {
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
    _playerCommandSubscription = _audioPlayer.notificationService.onPlayerCommand.listen((command) {
      print('Command: $command');
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if(mounted){
        setState(() {
          _playerState = state;
        });
      }
    });
    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if(mounted){
        _playerState = state;
      }
    });
    _playingRoute = PlayingRoute.SPEAKERS;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
        _duration != null &&
        _position!.inMilliseconds > 0 &&
        _position!.inMilliseconds < _duration!.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(audio.mediaLink!, position: playPosition);
    if(result==1){
      setState(()=>_playerState=PlayerState.PLAYING);
    }
    return result;
  }
  Future<int> _pause() async{
    final result = await _audioPlayer.pause();
    if(result == 1){
      setState(()=>_playerState=PlayerState.PAUSED);
    }
    return result;
  }
  Future<int> _earPieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if(result==1){
      setState(() =>_playingRoute = _playingRoute.toggle());
    }
    return result;
  }
  Future<int> stop() async {
    final result = await _audioPlayer.pause();
    if(result==1){
      setState(() {
        _playerState = PlayerState.STOPPED;
        _position = const Duration();
      });
    }
    return result;
  }
  _onComplete(){
    setState(()=>_playerState = PlayerState.STOPPED);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
