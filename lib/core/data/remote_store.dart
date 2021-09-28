import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ivugurura_app/core/models/list_page.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/utils/constants.dart';

final options = BaseOptions(
  baseUrl: API_APP_URL,
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

class RemoteStore {
  final Dio dio;
  RemoteStore({
    required this.dio
  });

  Future<ListPage<Topic>> getTopicsList({int pageNumber = 1, int pageSize = 20}) async {
    // print('Its getting topic lists ${dio.options}');
    try {

      final response = await dio.get('/topics');
      final result = json.decode(response.data);

      final jsonData = result['data'] as List;
      List<Topic> topicsData = jsonData.map((e) => Topic.fromJson(e)).toList();

      return ListPage<Topic>(
          itemList: topicsData, grandTotalCount: result['totalItems']);
    } catch (error) {
      if (error is DioError && error.error is SocketException) {
        throw error.error;
      }

      throw error;
    }
  }
}
