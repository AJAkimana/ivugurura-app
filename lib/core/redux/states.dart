import 'package:flutter/cupertino.dart';
import 'package:ivugurura_app/core/models.dart';

@immutable
class TopicsState{
  final bool isLoading;
  final String errorMessage;
  final List<Topic> topics;

  TopicsState({
    required this.isLoading,
    required this.errorMessage,
    required this.topics,
  });

  factory TopicsState.initial() => TopicsState(isLoading: false, errorMessage: '', topics: []);

  TopicsState copyWith({
    required bool isLoading,
    required String errorMessage,
    required List<Topic> topics,
  }){
    return TopicsState(
        errorMessage: errorMessage,
      isLoading: isLoading,
      topics: topics
    );
}
}