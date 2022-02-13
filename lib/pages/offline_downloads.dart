import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/utils/app_colors.dart';

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
    loadAllTask();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(DownloadClass.callback);
    super.initState();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: audioBluishBackground,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 120),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: downloadsListMap.length > 0
                    ? ListView.builder(
                        itemCount: downloadsListMap.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildList(context, downloadsListMap[index]);
                        },
                      )
                    : Center(child: Text("No Downloads yet")),
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu, color: Colors.white),
                      ),
                      Text(
                        'Downloaded audio',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, Map audio) {
    String fileName = audio['filename'];
    int progress = audio['progress'];
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
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
                Text(
                  fileName,
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Icon(Icons.supervised_user_circle_outlined,
                        color: secondaryColor, size: 20),
                    SizedBox(width: 5),
                    Text('Author',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 13,
                          letterSpacing: 3
                      ),
                    )
                  ],
                ),
                Column(
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
}

class DownloadClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName(DOWNLOADER_PORT_NAME);
    sendPort!.send([id, status, progress]);
  }
}
