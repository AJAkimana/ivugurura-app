import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base_action.dart';

Future<void> fetchTopics(BuildContext context,
    {int page = 1, int pageSize = 4, String category = 'carsoul'}) async {
  dynamic dispatchedAction;
  dispatchedAction = DispatchedAction<Topic, CarouselTopic>();
  if (category == 'recent') {
    dispatchedAction = DispatchedAction<Topic, RecentTopic>();
  }
  appStore.dispatch(dispatchedAction.pending());
  try {
    String url = '$topicsUrl?page=$page&pageSize=$pageSize&category=$category';
    String? acceptLang =
        LocalizedApp.of(context).delegate.currentLocale.languageCode;

    final res = await http
        .get(Uri.parse(url), headers: {'Accept-Language': acceptLang});

    assert(res.statusCode < 400);

    final jsonData = json.decode(res.body)['data'] as List;
    List<Topic> topicsData = jsonData.map((e) => Topic.fromJson(e)).toList();

    appStore.dispatch(dispatchedAction.fulfilled(topicsData));
  } catch (error) {
    print('{=======================');
    print(error);
    print('=========================}');
    appStore.dispatch(dispatchedAction.rejected(error.toString()));
  }
}

Future<void> fetchTopicDetail(BuildContext context, String topicSlug) async {
  DispatchedAction<Topic, TopicDetail> dispatchedAction;

  dispatchedAction = DispatchedAction<Topic, TopicDetail>();

  appStore.dispatch(dispatchedAction.pending());
  try {
    final uri = Uri.parse('$topicsUrl/$topicSlug');
    String? acceptLang =
        LocalizedApp.of(context).delegate.currentLocale.languageCode;

    final res = await http.get(uri, headers: {'Accept-Language': acceptLang});
    assert(res.statusCode < 400);
    final jsonData = json.decode(res.body)['data'];
    Topic topicData = Topic.fromJson(jsonData);
    appStore
        .dispatch(dispatchedAction.fulfilled(topicData, dataType: 'object'));
  } catch (error) {
    print('{=======================');
    print(error.toString());
    print('=========================}');
    appStore.dispatch(dispatchedAction.rejected(error.toString()));
  }
}
