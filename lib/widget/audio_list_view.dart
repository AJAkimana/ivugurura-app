import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/core/models/audio.dart';
import 'package:ivugurura_app/core/redux/actions/audio_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/pages/offline_downloads.dart';
import 'package:ivugurura_app/widget/audio_item.dart';
import 'package:ivugurura_app/widget/audio_player_widget.dart';
import 'package:ivugurura_app/widget/badge.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/no_display_data.dart';
import 'package:ivugurura_app/widget/player_controls.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ivugurura_app/core/extensions/string_cap_extension.dart';

class AudioListView extends StatefulWidget {
  final Repository repository;
  const AudioListView({
    Key? key,
    required this.repository,
  }) : super(key: key);

  _AudioListViewState createState() => _AudioListViewState();
}

class _AudioListViewState extends State<AudioListView> {
  Repository get _repository => widget.repository;
  final int pageSize = 10;
  Audio currentAudio = Audio();
  bool _play = false;
  int _currentIndex = 0;
  int _totalDownLoads = 0;

  final pagingController = PagingController<int, Audio>(firstPageKey: 1);

  Future<void> fetchPage(int pageKey) async {
    try {
      final newPage = await _repository.getListAudios(pageKey, pageSize);
      final previouslyFetchedItemsCount =
          pagingController.itemList?.length ?? 0;
      final isLastPage = newPage.isLastPage(previouslyFetchedItemsCount);
      final newItems = newPage.itemList;

      if (pageKey == 1 && newItems.length > 0) {
        setCurrentAudio(newItems[_currentIndex]);
      }
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void initState() {
    FlutterDownloader.registerCallback(DownloadClass.callback);
    _countDownloads();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double topHeight = height * 0.3;
    return StoreConnector<AppState, BaseState<Audio, AudioDetail>>(
        distinct: true,
        converter: (store) => store.state.currentAudio,
        builder: (context, audioState) {
          final theAudio = audioState.theObject!;
          String mediaUrl = "$AUDIO_PATH/${theAudio.mediaLink ?? ''}";
          return Scaffold(
            backgroundColor: Colors.lightBlue,
            appBar: AppBar(
              title: Text('Audio'),
              actions: <Widget>[
                BadgeIcon(
                    child: IconButton(
                        onPressed: _goToDownloadScreen,
                        icon: Icon(Icons.download)
                    ),
                    value: '$_totalDownLoads'
                )
                // IconButton(onPressed: () {}, icon: Icon(Icons.share))
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Stack(
                    children: <Widget>[
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 16),
                        child: Text(theAudio.title ?? ''),
                      )),
                      Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                  height: topHeight,
                                  width: MediaQuery.of(context).size.width,
                                  child: AudioPlayerWidget(
                                    mediaUrl: Uri.encodeFull(mediaUrl),
                                    play: _play,
                                    onPlay: onSetPlay,
                                  ))
                            ],
                          ),
                          Container(
                              height: height * 0.6,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [0, 0.5, 1],
                                      colors: [
                                    Color(0xFF014F82),
                                    Color(0xff00395f),
                                    Color(0xFF001726)
                                  ])),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 25),
                                  // Text(' Buffering... ',
                                  //     style: TextStyle(color: Colors.white, fontSize: 25)),
                                  // _progress(),
                                  Expanded(
                                      child: RefreshIndicator(
                                    onRefresh: () => Future.sync(
                                        () => pagingController.refresh()),
                                    child: PagedListView.separated(
                                      physics: BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      pagingController: pagingController,
                                      builderDelegate:
                                          PagedChildBuilderDelegate<Audio>(
                                              itemBuilder:
                                                  (context, audio, index) {
                                                int audioIndex =
                                                    pagingController.itemList!
                                                        .indexWhere((au) =>
                                                            au.slug ==
                                                            audio.slug);
                                                return AudioItem(
                                                  audio: audio,
                                                  audioIndex: index,
                                                  onSetCurrent: () {
                                                    setCurrent(audio);
                                                    setState(() {
                                                      _play = true;
                                                      _currentIndex =
                                                          audioIndex;
                                                    });
                                                  },
                                                  currentAudio: theAudio,
                                                  onDownloadCurrent: _addToDownload,
                                                );
                                              },
                                              firstPageErrorIndicatorBuilder:
                                                  (context) {
                                                print(pagingController.error);
                                                return DisplayError(
                                                  error: pagingController.error,
                                                  onTryAgain: () =>
                                                      pagingController
                                                          .refresh(),
                                                );
                                              },
                                              noItemsFoundIndicatorBuilder:
                                                  (context) => NoDisplayData()),
                                      padding: const EdgeInsets.all(8),
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 1);
                                      },
                                    ),
                                  ))
                                ],
                              )
                          )
                        ],
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.15,
                        top: topHeight - 35,
                        child: FractionalTranslation(
                          translation: Offset(0, 0.5),
                          child: PlayControls(
                            isPlaying: _play,
                            prevEnableFeedback: _currentIndex != 0,
                            nextEnableFeedback: pagingController.itemList != null
                                ? _currentIndex != pagingController.itemList!.length - 1
                                : false,
                            onSetPrev: () {
                              onSetNextOrPrev(action: 'prev');
                            },
                            onSetPlay: onSetPlay,
                            onSetNext: () {
                              onSetNextOrPrev();
                            },
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          );
        });
  }

  onSetPlay() {
    setState(() {
      _play = !_play;
    });
  }


  void setCurrent(Audio _audio) {
    setCurrentAudio(_audio);
  }

  void onSetNextOrPrev({String action = 'next'}) {
    int nextIndex = _currentIndex + 1;
    if (_currentIndex == pagingController.itemList!.length - 1 &&
        action == 'next') {
      return;
    }
    if (action == 'prev') {
      if (_currentIndex == 0) {
        return;
      }
      nextIndex = _currentIndex - 1;
    }
    setCurrent(pagingController.itemList![nextIndex]);
    setState(() {
      _currentIndex = nextIndex;
      _play = true;
    });
  }

  Future _countDownloads() async {
    List<DownloadTask>? allTasks = await FlutterDownloader.loadTasks();
    setState(() {
      _totalDownLoads = allTasks!.length;
    });
  }

  void _goToDownloadScreen(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => OfflineDownloads()));
  }

  Future<void> _addToDownload(Audio audio) async {
    final status = await Permission.storage.request();
    if(status.isGranted){
      String mediaUrl = "$AUDIO_PATH/${(audio.mediaLink?? '')}";
      String title = '${audio.title!.trim().toLowerCase().capitalizeFirstOfEach}.mp3';
      final dir = await getExternalStorageDirectory();
      // var localPath = dir.path + '/' + (audio.title?? '');
      // final savedDir = Directory(localPath);

      List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
      bool exist = tasks!.map((el) => el.filename).contains(title);
      if (exist==false) {
        setState(() {
          _totalDownLoads = tasks.length + 1;
        });
        await FlutterDownloader.enqueue(
            url: Uri.encodeFull(mediaUrl),
            fileName: title,
            savedDir: dir!.path,
            showNotification: true,
            openFileFromNotification: true
        );
      }else{
        final snackBar = SnackBar(
          content: Text(translate('downloads.download_exist', args: {'song_title':audio.title})),
          action: SnackBarAction(
            label: 'Downloads',
            onPressed: _goToDownloadScreen,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }else{
      final snackBar = SnackBar(
        content: Text('Need permission'),
        action: SnackBarAction(
          label: 'Enable permission',
          onPressed: () async {
            await openAppSettings();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
