import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ivugurura_app/core/models/audio.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:ivugurura_app/utils/app_colors.dart';

class OfflineDownloads extends StatefulWidget{
  OfflineDownloads({Key? key}):super(key: key);

  _OfflineDownloads createState()=>_OfflineDownloads();
}

class _OfflineDownloads extends State<OfflineDownloads>{
  ReceivePort _port = ReceivePort();
  List<Map> downloadsListMap = [];
  static const DOWNLOADER_PORT_NAME = 'downloader_send_port';

  List<Audio> downloaded=[
    Audio(title: 'A text title with a lot of characters text title with a lot of characters text title with a lot of characters', author: 'Mugunga Pierre'),
    Audio(title: 'A text title with a lot of characters', author: 'Mugunga Pierre')
  ];

  @override
  void initState() {
    loadAllTask();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
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
      backgroundColor: appPrimaryColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 145),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: downloaded.length,
                  itemBuilder: (BuildContext context, int index){
                    return buildList(context, downloaded[index]);
                  },
                ),
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu, color: Colors.white),
                      ),
                      Text('Downloaded audio',
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

  Widget buildList(BuildContext context, Audio audio){
    // Map _map = Map();
    // String _filename = _map['filename'];
    // int _progress = _map['progress'];
    // DownloadTaskStatus _status = _map['status'];
    // String _id = _map['id'];
    // String _savedDirectory = _map['savedDirectory'];
    // List<FileSystemEntity> _directories = Directory(_savedDirectory).listSync(followLinks: true);
    // FileSystemEntity? _file = _directories.isNotEmpty ? _directories?.first : null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white
      ),
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(audio.title as String,
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Icon(Icons.supervised_user_circle_outlined, color: secondaryColor, size: 20),
                    SizedBox(width: 5),
                    Text(audio.author as String,
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
                      Text('23%'),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: LinearProgressIndicator(
                              value: 23 / 100,
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
  void _bindBackgroundIsolate(){
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, DOWNLOADER_PORT_NAME);
    if(!isSuccess){
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
  void _unbindBackgroundIsolate(){
    IsolateNameServer.removePortNameMapping(DOWNLOADER_PORT_NAME);
  }
  static void downloadCallback(String id, DownloadTaskStatus status, int progress){
    final SendPort? sendPort = IsolateNameServer.lookupPortByName(DOWNLOADER_PORT_NAME);
    sendPort!.send([id, status, progress]);
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