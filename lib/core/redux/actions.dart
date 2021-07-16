import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ivugurura_app/core/models.dart';
import 'package:ivugurura_app/core/redux/states.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:redux/redux.dart';

@immutable
class TopicsActions{
  final TopicsState topicsState;

  TopicsActions(this.topicsState);
}

Future<void> fetchTopics(Store<AppState> store) async {
  store.dispatch(TopicsActions(TopicsState(isLoading: true)));
  try{
    final res = await http.get(Uri.https(topicsUrl, '/'));
    assert(res.statusCode > 400);
    final jsonData = json.decode(res.body) as List;
    List<Topic> topicsData = jsonData.map((e) => Topic.fromJson(e)).toList();
    store.dispatch(TopicsActions(TopicsState(isLoading: false, topics: topicsData)));
  } catch (error){
    store.dispatch(TopicsActions(TopicsState(isLoading: false, errorMessage: error.toString())));
  }
}