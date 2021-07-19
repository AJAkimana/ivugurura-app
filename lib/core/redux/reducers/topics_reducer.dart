import 'package:ivugurura_app/core/redux/actions/topic_actions.dart';
import 'package:ivugurura_app/core/redux/states/topics_states.dart';

topicsReducer(TopicsState prevState, TopicsActions actions){
  final payload = actions.topicsState;
  return prevState.copyWith(
      loading: payload.loading,
      loaded: payload.loaded,
      error: payload.error,
      topics: payload.topics
  );
}