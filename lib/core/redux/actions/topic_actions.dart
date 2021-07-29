import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ivugurura_app/core/models.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/core/utils/constants.dart';

import '../base_action.dart';


Future<void> fetchTopics({int page=1, int pageSize=4, String category='carsoul'}) async {
  DispatchedAction<Topic> dispatchedAction = DispatchedAction();
  appStore.dispatch(dispatchedAction.pending());
  try{
    String url = '$topicsUrl?page=$page&pageSize=$pageSize&category=$category';
    final res = await http.get(
          Uri.parse(url),
          headers: {'Accept-Language': 'kn'}
        );
    assert(res.statusCode < 400);
    final jsonData = json.decode(res.body)['data'] as List;
    List<Topic> topicsData = jsonData.map((e) => Topic.fromJson(e)).toList();
    dispatchedAction.setActionValue(topicsData);
    appStore.dispatch(dispatchedAction.fulfilled());
  } catch (error){
    print('{=======================');
    print(error);
    print(topicsUrl);
    print('=========================}');
    dispatchedAction.setActionValue(error.toString());
    appStore.dispatch(dispatchedAction.rejected());
  }
}