import 'package:flutter/cupertino.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/redux/base_action.dart';
import 'package:ivugurura_app/core/redux/base_reducer.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

AppState appReducer(AppState state, dynamic action){
  if(action is BaseAction<Topic, CarouselTopic>){
    return state.copyWith(
        carouselTopicState: baseReducer(state.carouselTopicState, action)
    );
  }
  if(action is BaseAction<Topic, RecentTopic>){
    return state.copyWith(
        recentTopicState: baseReducer(state.recentTopicState, action)
    );
  }
  if(action is BaseAction<Topic, TopicDetail>){
    return state.copyWith(
        topicDetailState: baseReducer(state.topicDetailState, action)
    );
  }
  return state;
}

@immutable
class AppState{
  final BaseState<Topic, CarouselTopic> carouselTopicState;
  final BaseState<Topic, RecentTopic> recentTopicState;
  final BaseState<Topic, TopicDetail> topicDetailState;

  AppState({
    required this.carouselTopicState,
    required this.recentTopicState,
    required this.topicDetailState
  });

  AppState copyWith({
    BaseState<Topic, CarouselTopic>? carouselTopicState,
    BaseState<Topic, RecentTopic>? recentTopicState,
    BaseState<Topic, TopicDetail>? topicDetailState
  }){
    return AppState(
      carouselTopicState: carouselTopicState?? this.carouselTopicState,
      recentTopicState: recentTopicState?? this.recentTopicState,
      topicDetailState: topicDetailState?? this.topicDetailState
    );
  }
}


class ReduxStore{
  Topic topic() => new Topic();
  static Store<AppState> store() {
    // final topic = new Topic();
    return Store<AppState>(
        appReducer,
        middleware: [thunkMiddleware],
        initialState: AppState(
          carouselTopicState: BaseState<Topic, CarouselTopic>.initial(()=>new Topic()),
          recentTopicState: BaseState<Topic, RecentTopic>.initial(()=>new Topic()),
          topicDetailState: BaseState<Topic, TopicDetail>.initial(()=>new Topic(),dataType: 'object'),
        )
    );
  }
}

Store<AppState> appStore = ReduxStore.store();
