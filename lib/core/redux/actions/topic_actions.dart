import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ivugurura_app/core/models/home_content.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';

import '../base_action.dart';

Future<void> fetchTopics(BuildContext context,
    {int page = 1, int pageSize = 4, dynamic category = 'carsoul'}) async {
  dynamic dispatchedAction;
  dispatchedAction = DispatchedAction<Topic, CarouselTopic>();
  if (category == 'recent') {
    dispatchedAction = DispatchedAction<Topic, RecentTopic>();
  }
  if (category is int) {
    dispatchedAction = DispatchedAction<Topic, CategoryTopic>();
  }
  appStore.dispatch(dispatchedAction.pending());
  try {
    String url = '$topicsUrl?page=$page&pageSize=$pageSize&category=$category';
    String? acceptLang = await getLangFromPrefs();

    final res = await http
        .get(Uri.parse(url), headers: {'Accept-Language': acceptLang});

    assert(res.statusCode < 400);

    final jsonData = json.decode(res.body)['data'] as List;
    List<Topic> topicsData = jsonData.map((e) => Topic.fromJson(e)).toList();

    appStore.dispatch(dispatchedAction.fulfilled(topicsData));
  } catch (error) {
    appStore.dispatch(dispatchedAction.rejected(error.toString()));
  }
}

Future<void> fetchTopicDetail(BuildContext context, String topicSlug) async {
  DispatchedAction<Topic, TopicDetail> dispatchedAction;

  dispatchedAction = DispatchedAction<Topic, TopicDetail>();

  appStore.dispatch(dispatchedAction.pending());
  try {
    final uri = Uri.parse('$topicsUrl/$topicSlug');
    String? acceptLang = await getLangFromPrefs();

    final res = await http.get(uri, headers: {'Accept-Language': acceptLang});
    assert(res.statusCode < 400);
    final jsonData = json.decode(res.body)['data'];
    Topic topicData = Topic.fromJson(jsonData);
    appStore
        .dispatch(dispatchedAction.fulfilled(topicData, dataType: 'object'));
  } catch (error) {
    appStore.dispatch(dispatchedAction.rejected(error.toString()));
  }
}

Future<void> fetchHomeContents(BuildContext context) async {
  DispatchedAction<HomeContent, HomeContentObject> dispatchedAction;

  dispatchedAction = DispatchedAction<HomeContent, HomeContentObject>();

  appStore.dispatch(dispatchedAction.pending());
  try {
    final uri = Uri.parse(homeContentUrl);
    String? acceptLang = await getLangFromPrefs();

    final res = await http.get(uri, headers: {'Accept-Language': acceptLang});
    assert(res.statusCode < 400);
    final jsonData = json.decode(res.body)['data'];
    final contentData = HomeContent.fromJson(jsonData);
    appStore
        .dispatch(dispatchedAction.fulfilled(contentData, dataType: 'object'));
  } catch (error) {
    appStore.dispatch(dispatchedAction.rejected(error.toString()));
  }
}
