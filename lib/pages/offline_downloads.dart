import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/utils/app_colors.dart';
import 'package:ivugurura_app/widget/player_controls.dart';

const DOWNLOADER_PORT_NAME = 'downloader_send_port';

class OfflineDownloads extends StatefulWidget {
  OfflineDownloads({Key? key}) : super(key: key);

  _OfflineDownloads createState() => _OfflineDownloads();
}

class _OfflineDownloads extends State<OfflineDownloads> {
  ReceivePort _port = ReceivePort();
  List<Map> downloadsListMap = [];

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
    return Scaffold(
        appBar: AppBar(
          title: Text('Downloaded audios'),
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
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                              child: Text(
                            'Songs and preachings',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                        ],
                      ),
                      SizedBox(height: 5),
                      PlayControls(
                        width: 1,
                        onSetPrev: () {},
                        onSetPlay: () {},
                        onSetNext: () {},
                      )
                    ],
                  ),
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
                    : Center(child: Text("No Downloads yet")),
              )
            ],
          ),
        )
    );
  }

  Widget buildList(BuildContext context, int index) {
    Map audio = downloadsListMap[index];
    String taskId = audio['id'];
    String fileName = audio['filename'];
    int progress = audio['progress'];
    DownloadTaskStatus status = audio['status'];
    print('=======>');
    print(status==DownloadTaskStatus.running);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white60),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: Text(
                      fileName,
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                    _buttons(status, taskId, index)
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Icon(Icons.supervised_user_circle_outlined,
                        color: secondaryColor, size: 20),
                    SizedBox(width: 5),
                    Text(
                      'Author',
                      style: TextStyle(
                          color: primaryColor, fontSize: 13, letterSpacing: 3),
                    )
                  ],
                ),
                progress == 100
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
    });
    setState(() {});
  }

  Widget _downloadStatus(DownloadTaskStatus _status) {
    return _status == DownloadTaskStatus.canceled
        ? Text('Download canceled')
        : _status == DownloadTaskStatus.complete
            ? Text('Download completed')
            : _status == DownloadTaskStatus.failed
                ? Text('Download failed')
                : _status == DownloadTaskStatus.paused
                    ? Text('Download paused')
                    : _status == DownloadTaskStatus.running
                        ? Text('Downloading..')
                        : Text('Download waiting');
  }

  Widget _buttons(DownloadTaskStatus _status, String _id, int index) {
    void changeTaskID(String oldTaskId, String newTaskID) {
      Map task =
          downloadsListMap.firstWhere((element) => element['id'] == oldTaskId);
      task['id'] = newTaskID;
      print(task);
      setState(() {});
    }
    Map task = downloadsListMap[index];
    print('=======================>');
    print(_status);
    // Map task =
    // downloadsListMap.firstWhere((element) => element['id'] == taskId);
    // print(task);
    // print(_status == DownloadTaskStatus.complete);
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
                : _status == DownloadTaskStatus.running && task['progress'] != 100
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
                    : task['progress'] == 100
                        ? GestureDetector(
                            child:
                                Icon(Icons.delete, size: 20, color: Colors.red),
                            onTap: () {
                              downloadsListMap.removeAt(index);
                              FlutterDownloader.remove(
                                  taskId: _id, shouldDeleteContent: true);
                              setState(() {});
                            },
                          )
                        : Container();
  }
}

class DownloadClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName(DOWNLOADER_PORT_NAME);
    sendPort!.send([id, status, progress]);
  }
}
