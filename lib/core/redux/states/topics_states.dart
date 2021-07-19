import 'package:flutter/cupertino.dart';
import 'package:ivugurura_app/core/models.dart';

@immutable
class TopicsState{
  final bool? loading, loaded;
  final String? error;
  final List<Topic>? topics;

  TopicsState({
    this.loading,
    this.loaded,
    this.error,
    this.topics,
  });

  factory TopicsState.initial() => TopicsState(
      loading: false,
      loaded: false,
      error: null,
      topics: []
  );

  TopicsState copyWith({
    bool? loading,
    bool? loaded,
    String? error,
    List<Topic>? topics,
  }){
    return TopicsState(
      loading: loading?? this.loading,
      loaded: loaded?? this.loaded,
      error: error?? this.error,
      topics: topics??this.topics
    );
  }
}