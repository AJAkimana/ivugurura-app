import 'package:flutter/cupertino.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/core/redux/base_action.dart';
import 'package:ivugurura_app/core/redux/base_reducer.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

AppState appReducer(AppState state, dynamic action){
  if(action is BaseAction<Topic, CarouselTopic>){
    final nextCarouselTopicState = baseReducer(state.carouselTopicState, action);

    return state.copyWith(carouselTopicState: nextCarouselTopicState);
  }
  if(action is BaseAction<Topic, RecentTopic>){
    final nextRecentTopicState = baseReducer(state.recentTopicState, action);

    return state.copyWith(recentTopicState: nextRecentTopicState);
  }
  return state;
}

@immutable
class AppState{
  final BaseState<Topic, CarouselTopic> carouselTopicState;
  final BaseState<Topic, RecentTopic> recentTopicState;

  AppState({
    required this.carouselTopicState,
    required this.recentTopicState
  });

  AppState copyWith({
    BaseState<Topic, CarouselTopic>? carouselTopicState,
    BaseState<Topic, RecentTopic>? recentTopicState,
  }){
    return AppState(
      carouselTopicState: carouselTopicState?? this.carouselTopicState,
      recentTopicState: recentTopicState?? this.recentTopicState
    );
  }
}


class ReduxStore{
  static Store<AppState> store() {
    final carouselTopicInitialState = BaseState<Topic, CarouselTopic>.initial();
    final recentTopicInitialState = BaseState<Topic, RecentTopic>.initial();


    return Store<AppState>(
        appReducer,
        middleware: [thunkMiddleware],
        initialState: AppState(
          carouselTopicState: carouselTopicInitialState,
          recentTopicState: recentTopicInitialState
        )
    );
  }
}

Store<AppState> appStore = ReduxStore.store();
