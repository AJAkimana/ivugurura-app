import 'package:ivugurura_app/core/redux/actions.dart';
import 'package:ivugurura_app/core/redux/states.dart';

topicsReducer(TopicsState prevState, TopicsActions actions){
  final payload = actions.topicsState;
  return prevState.copyWith(
      isLoading: payload!.isLoading,
      errorMessage: payload.errorMessage,
      topics: payload.topics
  );
}