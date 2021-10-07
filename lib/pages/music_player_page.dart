import 'dart:async';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/widget/playing_contols.dart';
import 'package:ivugurura_app/widget/position_seek_widget.dart';
import 'package:ivugurura_app/widget/songs_selector.dart';

class MusicPlayerPage extends StatefulWidget {
  final Repository repository;
  const MusicPlayerPage({
    Key? key,
    required this.repository,
  }) : super(key: key);

  @override
  _MusicPlayerPage createState() => _MusicPlayerPage();
}

class _MusicPlayerPage extends State<MusicPlayerPage> {
  Repository get _repository => widget.repository;
  final List<Audio> audios = [];
  Future<void> fetchPage() async {
    try {
      final newPage = await _repository.getListAudios(1, 10);
      final newItems = newPage.itemList;
     for (var audio in newItems){
        audios.add(Audio.network(
          AUDIO_PATH + audio.mediaLink!,
          metas: Metas(
            id: audio.slug,
            title: audio.title,
            artist: audio.author,
            album: 'Indirimbo',
          ),
        ));
      }
    } catch (error) {
      print('===========================================>${error}');
    }
  }

  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _subscriptions.add(_assetsAudioPlayer.playlistAudioFinished.listen((data) {
      print('playlistAudioFinished : $data');
    }));
    _subscriptions.add(_assetsAudioPlayer.audioSessionId.listen((sessionId) {
      print('audioSessionId : $sessionId');
    }));
    _subscriptions
        .add(AssetsAudioPlayer.addNotificationOpenAction((notification) {
      return false;
    }));
    openPlayer();
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    print('dispose');
    super.dispose();
  }

  void openPlayer() async {
    await fetchPage();
    await _assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: 0),
      showNotification: true,
      autoStart: false,
    );
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              _assetsAudioPlayer.builderCurrent(
                builder: (BuildContext context, Playing playing) {
                  print('Building======>');
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 8,
                        surfaceIntensity: 1,
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.circle(),
                      ),
                      child: Image.asset(
                        'assets/soundcloud.jpg',
                        height: 150,
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          _assetsAudioPlayer.builderCurrent(
              builder: (context, Playing? playing) {
                print('Building 2=======>');
                return Column(
                  children: <Widget>[
                    _assetsAudioPlayer.builderLoopMode(
                      builder: (context, loopMode) {
                        return PlayerBuilder.isPlaying(
                            player: _assetsAudioPlayer,
                            builder: (context, isPlaying) {
                              return PlayingControls(
                                loopMode: loopMode,
                                isPlaying: isPlaying,
                                isPlaylist: true,
                                onStop: () {
                                  _assetsAudioPlayer.stop();
                                },
                                toggleLoop: () {
                                  _assetsAudioPlayer.toggleLoop();
                                },
                                onPlay: () {
                                  _assetsAudioPlayer.playOrPause();
                                },
                                onNext: () {
                                  //_assetsAudioPlayer.forward(Duration(seconds: 10));
                                  _assetsAudioPlayer.next(keepLoopMode: true
                                    /*keepLoopMode: false*/);
                                },
                                onPrevious: () {
                                  _assetsAudioPlayer.previous(
                                    /*keepLoopMode: false*/);
                                },
                              );
                            });
                      },
                    ),
                    _assetsAudioPlayer.builderRealtimePlayingInfos(
                        builder: (context, RealtimePlayingInfos? infos) {
                          print('Realtime playing info ========>');
                          if (infos == null) {
                            return SizedBox();
                          }
                          return Column(
                            children: [
                              PositionSeekWidget(
                                currentPosition: infos.currentPosition,
                                duration: infos.duration,
                                seekTo: (to) {
                                  _assetsAudioPlayer.seek(to);
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NeumorphicButton(
                                    onPressed: () {
                                      _assetsAudioPlayer
                                          .seekBy(Duration(seconds: -10));
                                    },
                                    child: Text('-10'),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  NeumorphicButton(
                                    onPressed: () {
                                      _assetsAudioPlayer
                                          .seekBy(Duration(seconds: 10));
                                    },
                                    child: Text('+10'),
                                  ),
                                ],
                              )
                            ],
                          );
                        }),
                  ],
                );
              }),
          SizedBox(
            height: 20,
          ),
          _assetsAudioPlayer.builderCurrent(
              builder: (BuildContext context, Playing? playing) {
                return SongsSelector(
                  audios: audios,
                  onPlaylistSelected: (myAudios) {
                    _assetsAudioPlayer.open(
                      Playlist(audios: myAudios),
                      showNotification: true,
                      headPhoneStrategy:
                      HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                      audioFocusStrategy: AudioFocusStrategy.request(
                          resumeAfterInterruption: true),
                    );
                  },
                  onSelected: (myAudio) async {
                    try {
                      await _assetsAudioPlayer.open(
                        myAudio,
                        autoStart: true,
                        showNotification: true,
                        playInBackground: PlayInBackground.enabled,
                        audioFocusStrategy: AudioFocusStrategy.request(
                            resumeAfterInterruption: true,
                            resumeOthersPlayersAfterDone: true),
                        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  playing: playing,
                );
              }),
        ],
      ),
    );
  }
}
