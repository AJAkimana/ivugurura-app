import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ivugurura_app/core/models.dart';
import 'package:ivugurura_app/core/redux/states/topics_states.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:redux/redux.dart';

@immutable
class TopicsActions{
  final TopicsState topicsState;

  TopicsActions(this.topicsState);
}

Future<void> fetchTopics(Store<AppState> store) async {
  store.dispatch(TopicsActions(TopicsState(loading: true)));
  try{
    final res = await http.get(Uri.parse(topicsUrl));
    assert(res.statusCode < 400);
    final jsonData = json.decode(res.body)['data'] as List;
    // print(jsonData);
    List<Topic> topicsData = jsonData.map((e) => Topic.fromJson(e)).toList();
    store.dispatch(TopicsActions(TopicsState(loading: false, loaded: true, topics: topicsData)));
  } catch (error){
    print('{=======================');
    print(error);
    print(topicsUrl);
    print('=========================}');
    store.dispatch(TopicsActions(TopicsState(loading: false, error: error.toString())));
  }
}