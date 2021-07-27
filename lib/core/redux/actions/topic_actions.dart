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

Future<void> fetchTopics({int page=1, int pageSize=4, String category='carsoul'}) async {
  appStore.dispatch(TopicsActions(TopicsState(loading: true)));
  try{
    String url = '$topicsUrl?page=$page&pageSize=$pageSize&category=$category';
    final res = await http.get(
          Uri.parse(url),
          headers: {'Accept-Language': 'kn'}
        );
    assert(res.statusCode < 400);
    final jsonData = json.decode(res.body)['data'] as List;
    // print(jsonData);
    List<Topic> topicsData = jsonData.map((e) => Topic.fromJson(e)).toList();
    appStore.dispatch(TopicsActions(TopicsState(loading: false, loaded: true, topics: topicsData)));
  } catch (error){
    print('{=======================');
    print(error);
    print(topicsUrl);
    print('=========================}');
    appStore.dispatch(TopicsActions(TopicsState(loading: false, error: error.toString())));
  }
}