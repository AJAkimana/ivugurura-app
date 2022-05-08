import 'dart:isolate';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ivugurura_app/core/models/audio.dart' as theAudio;
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/utils/app_colors.dart';
import 'package:ivugurura_app/widget/audio_player_widget.dart';
import 'package:ivugurura_app/core/extensions/string_cap_extension.dart';

const DOWNLOADER_PORT_NAME = 'downloader_send_port';
final assetsAudioPlayer = AssetsAudioPlayer();

class OfflineDownloads extends StatefulWidget {
  OfflineDownloads({Key? key}) : super(key: key);

  _OfflineDownloads createState() => _OfflineDownloads();
}

class _OfflineDownloads extends State<OfflineDownloads> {
  ReceivePort _port = ReceivePort();
  List<Map> downloadsListMap = [];
  List<theAudio.Audio> downloaded = [];
  theAudio.Audio currentAudio = theAudio.Audio();
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
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(translate('downloads.download_title')),
        ),
        backgroundColor: audioBluishBackground,
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(children: <Widget>[
              Center(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: Text(currentAudio.title ?? ''),
              )),
              Column(children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                        height: height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: AudioPlayerWidget(
                          mediaUrl: currentAudio.mediaLink ?? '',
                          play: false,
                          isNetwork: false,
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
                            stops: [
                          0,
                          0.5,
                          1
                        ],
                            colors: [
                          Color(0xFF014F82),
                          Color(0xff00395f),
                          Color(0xFF001726)
                        ])),
                    child: Column(children: <Widget>[
                      SizedBox(height: 5),
                      Expanded(
                          child: downloadsListMap.length > 0
                              ? ListView.builder(
                                  itemCount: downloadsListMap.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return buildList(context, index);
                                  },
                                )
                              : Center(
                                  child: Text(
                                      translate('downloads.download_no_data'))))
                    ]))
              ])
            ])));
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
          color: audio['filename'] == currentAudio.title
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
                      setPlayAudio(index);
                    }
                  },
                  onLongPress: () {
                    showDeleteSnackbar(index);
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
      Map task = Map();
      task['status'] = element.status;
      task['progress'] = element.progress;
      task['id'] = element.taskId;
      task['filename'] = element.filename;
      task['savedDirectory'] = element.savedDir;
      downloadsListMap.add(task);
      if (element.status == DownloadTaskStatus.complete) {
        downloaded.add(theAudio.Audio(
            title: element.filename,
            mediaLink: '${element.savedDir}/${element.filename}'));
      }
    });
    setState(() {
      if (downloaded.length > 0) {
        currentAudio = downloaded[0];
      }
    });
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
                              setPlayAudio(index);
                              // playAudio(index, true);
                              // downloadsListMap.removeAt(index);
                              // FlutterDownloader.remove(
                              //     taskId: _id, shouldDeleteContent: true);
                              // setState(() {});
                            },
                          )
                        : Container();
  }

  void setPlayAudio(int index) async {
    Map audio = downloadsListMap[index];
    // print('${audio['savedDirectory']}/${audio['filename']}');
    // setState(() {
    //   currentAudio = theAudio.Audio(
    //       title: audio['filename'],
    //       mediaLink: '${audio['savedDirectory']}/${audio['filename']}',
    //       author: 'Reformation voice');
    //   _isPlaying = true;
    // });
    // var filePath = "${audio['savedDirectory']}/${audio['filename']}";
    // final Uri uri = Uri.file(Uri.encodeFull(filePath));
    //
    // if (await File(uri.toFilePath()).exists()) {
    //   if (!await launchUrl(uri)) {
    //     throw 'Could not launch $uri';
    //   }
    // }else{
    //   throw 'No audio';
    // }
    // launchURL("file:${audio['savedDirectory']}/${audio['filename']}");
    FlutterDownloader.open(taskId: audio['id']);
  }

  void onSetPlay() {
    setState(() {
      if (currentAudio.title != null) {
        _isPlaying = !_isPlaying;
      }
    });
  }

  showDeleteSnackbar(int index) {
    Map audio = downloadsListMap[index];
    final snackBar = SnackBar(
      content: Text(translate('downloads.delete_download',
          args: {'song_title': audio['filename']})),
      action: SnackBarAction(
        label: 'Yes',
        onPressed: () async {
          FlutterDownloader.remove(
              taskId: audio['id'], shouldDeleteContent: false);
          downloadsListMap = [];
          await loadAllTask();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool isCurrentAudioEmpty() {
    return currentAudio.title != null;
  }
}

class DownloadClass {
  @pragma('vm:entry-point')
  static void callback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName(DOWNLOADER_PORT_NAME);
    sendPort!.send([id, status, progress]);
  }
}
