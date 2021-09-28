import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/data/in_memory_store.dart';
import 'package:ivugurura_app/core/data/remote_store.dart';
import 'package:ivugurura_app/core/models/list_page.dart';
import 'package:ivugurura_app/core/models/topic.dart';

class Repository {
  final RemoteStore remoteStore;
  final InMemoryStore inMemoryStore;

  Repository({required this.remoteStore, required this.inMemoryStore});

  Future<ListPage<Topic>> getListTopics() =>
      remoteStore.getTopicsList();
}
