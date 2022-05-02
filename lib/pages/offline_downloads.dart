import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/utils/app_colors.dart';
import 'package:ivugurura_app/widget/player_controls.dart';
import 'package:ivugurura_app/core/extensions/string_cap_extension.dart';

const DOWNLOADER_PORT_NAME = 'downloader_send_port';

class OfflineDownloads extends StatefulWidget {
  OfflineDownloads({Key? key}) : super(key: key);

  _OfflineDownloads createState() => _OfflineDownloads();
}

class _OfflineDownloads extends State<OfflineDownloads> {
  ReceivePort _port = ReceivePort();
  List<Map> downloadsListMap = [];
  final assetsAudioPlayer = AssetsAudioPlayer();
  Map currentAudio = {};
  int _currentIndex = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    loadAllTask();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(DownloadClass.callback);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var completed = downloadsListMap
        .where((element) => element['status'] == DownloadTaskStatus.complete);
    return Scaffold(
        appBar: AppBar(
          title: Text(translate('downloads.download_title')),
        ),
        backgroundColor: audioBluishBackground,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                // height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: downloadsListMap.length > 0
                      ? Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    child: Text(
                                  currentAudio.isEmpty
                                      ? translate(
                                          'downloads.songs_and_preachings')
                                      : currentAudio['filename'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                              ],
                            ),
                            SizedBox(height: 5),
                            completed.length > 0
                                ? PlayControls(
                                    width: 1,
                                    onSetPrev: () {
                                      onSetNextOrPrev(action: 'prev');
                                    },
                                    onSetPlay: () {
                                      if (currentAudio.isNotEmpty) {
                                        assetsAudioPlayer.playOrPause();
                                        setState(() {
                                          _isPlaying = !_isPlaying;
                                        });
                                      }
                                    },
                                    onSetNext: () {
                                      onSetNextOrPrev();
                                    },
                                    isPlaying: _isPlaying,
                                  )
                                : SizedBox(height: 5)
                          ],
                        )
                      : null,
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(top: 80),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: downloadsListMap.length > 0
                    ? ListView.builder(
                        itemCount: downloadsListMap.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildList(context, index);
                        },
                      )
                    : Center(
                        child: Text(translate('downloads.download_no_data'))),
              )
            ],
          ),
        ));
  }

  Widget buildList(BuildContext context, int index) {
    Map audio = downloadsListMap[index];
    String taskId = audio['id'];
    String fileName = audio['filename'];
    int progress = audio['progress'];
    DownloadTaskStatus status = audio['status'];
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: audio['filename'] == currentAudio['filename']
              ? Colors.lightBlueAccent
              : Colors.white60),
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          fileName.capitalizeFirstOfEach,
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      _buttons(status, taskId, index)
                    ],
                  ),
                  onTap: () {
                    if (status == DownloadTaskStatus.complete) {
                      playAudio(index);
                    }
                  },
                ),
                SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Icon(Icons.supervised_user_circle_outlined,
                        color: secondaryColor, size: 20),
                    SizedBox(width: 5),
                    Text(
                      'Reformation Voice',
                      style: TextStyle(
                          color: primaryColor, fontSize: 13, letterSpacing: 3),
                    )
                  ],
                ),
                status == DownloadTaskStatus.complete
                    ? Container()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('$progress%'),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: progress / 100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, DOWNLOADER_PORT_NAME);
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

    _port.listen((data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      var task = downloadsListMap.where((e) => e['id'] == id);
      task.forEach((element) {
        element['progress'] = progress;
        element['status'] = status;
        setState(() {});
      });
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(DOWNLOADER_PORT_NAME);
  }

  Future loadAllTask() async {
    List<DownloadTask>? allTasks = await FlutterDownloader.loadTasks();
    allTasks!.forEach((element) {
      // print(element);
      Map task = Map();
      task['status'] = element.status;
      task['progress'] = element.progress;
      task['id'] = element.taskId;
      task['filename'] = element.filename;
      task['savedDirectory'] = element.savedDir;
      downloadsListMap.add(task);
    });
    setState(() {});
  }

  Widget _buttons(DownloadTaskStatus _status, String _id, int index) {
    void changeTaskID(String oldTaskId, String newTaskID) {
      Map task =
          downloadsListMap.firstWhere((element) => element['id'] == oldTaskId);
      task['id'] = newTaskID;
      setState(() {});
    }

    return _status == DownloadTaskStatus.canceled
        ? GestureDetector(
            child: Icon(Icons.cached, size: 20, color: Colors.green),
            onTap: () {
              FlutterDownloader.retry(taskId: _id).then((newTaskID) {
                changeTaskID(_id, newTaskID!);
              });
            },
          )
        : _status == DownloadTaskStatus.failed
            ? GestureDetector(
                child: Icon(Icons.cached, size: 20, color: Colors.green),
                onTap: () {
                  FlutterDownloader.retry(taskId: _id).then((newTaskID) {
                    changeTaskID(_id, newTaskID!);
                  });
                },
              )
            : _status == DownloadTaskStatus.paused
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(Icons.play_arrow,
                            size: 20, color: Colors.blue),
                        onTap: () {
                          FlutterDownloader.resume(taskId: _id).then(
                            (newTaskID) => changeTaskID(_id, newTaskID!),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Icon(Icons.close, size: 20, color: Colors.red),
                        onTap: () {
                          FlutterDownloader.cancel(taskId: _id);
                        },
                      )
                    ],
                  )
                : _status == DownloadTaskStatus.running
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(Icons.pause,
                                size: 20, color: Colors.green),
                            onTap: () {
                              FlutterDownloader.pause(taskId: _id);
                            },
                          ),
                          GestureDetector(
                            child:
                                Icon(Icons.close, size: 20, color: Colors.red),
                            onTap: () {
                              FlutterDownloader.cancel(taskId: _id);
                            },
                          )
                        ],
                      )
                    : _status == DownloadTaskStatus.complete
                        ? GestureDetector(
                            child: Icon(Icons.pause_circle_filled_outlined,
                                size: 20, color: Colors.black),
                            onTap: () {
                              playAudio(index);
                              // downloadsListMap.removeAt(index);
                              // FlutterDownloader.remove(
                              //     taskId: _id, shouldDeleteContent: true);
                              // setState(() {});
                            },
                          )
                        : Container();
  }

  void playAudio(int index) {
    Map audio = downloadsListMap[index];
    String audioPath = '${audio['savedDirectory']}/${audio['filename']}';
    File _file = new File(audioPath);
    Audio _audio = Audio.file(_file.path);
    if (currentAudio.isEmpty) {
      _audio = Audio.file(_file.path,
          metas: Metas(
              title: audio['filename'],
              artist: 'Reformation voice',
              album: 'Audios'));
    } else if (audio['filename'] != currentAudio['filename']) {
      assetsAudioPlayer.stop();
      _audio.updateMetas(
        title: audio['filename'],
      );
    }
    setState(() {
      _isPlaying = true;
      _currentIndex = index;
      currentAudio = audio;
    });
    assetsAudioPlayer.open(_audio,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        showNotification: true,
        notificationSettings: NotificationSettings(customNextAction: (_) {
          onSetNextOrPrev();
        }, customPrevAction: (_) {
          onSetNextOrPrev(action: 'prev');
        }));
  }

  void onSetNextOrPrev({String action = 'next'}) {
    int nextIndex = _currentIndex + 1;
    if (_currentIndex == downloadsListMap.length - 1 && action == 'next') {
      return;
    }
    if (action == 'prev') {
      if (_currentIndex == 0) {
        return;
      }
      nextIndex = _currentIndex - 1;
    }
    playAudio(nextIndex);
  }
}

class DownloadClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName(DOWNLOADER_PORT_NAME);
    sendPort!.send([id, status, progress]);
  }
}
