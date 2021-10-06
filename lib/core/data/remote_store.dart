import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ivugurura_app/core/models/audio.dart';
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
  RemoteStore({required this.dio});

  Future<ListPage<Topic>> getTopicsList(
      {int pageNumber = 1, int pageSize = 20, int categoryId = 0}) async {
    try {
      String params = 'page=$pageNumber&pageSize=$pageSize';
      if (categoryId != 0) {
        params += '&category=$categoryId';
      }
      final response = await dio.get('/topics?$params');
      final result = response.data;

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

  Future<ListPage<Audio>> getAudiosList(int pageNumber, int pageSize) async {
    try {
      String params = 'page=$pageNumber&pageSize=$pageSize';
      final response = await dio.get('/albums/medias/audio?$params');
      final result = response.data;

      final jsonData = result['data'] as List;
      List<Audio> audiosData = jsonData.map((e) => Audio.fromJson(e)).toList();

      return ListPage<Audio>(
          itemList: audiosData, grandTotalCount: result['totalItems']);
    } catch (error) {
      if (error is DioError && error.error is SocketException) {
        throw error.error;
      }

      throw error;
    }
  }
}
