import 'package:flutter/cupertino.dart';
import 'package:ivugurura_app/core/redux/base_action.dart';
import 'package:ivugurura_app/core/redux/base_reducer.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../models.dart';

AppState appReducer(AppState state, dynamic action){
  if(action is BaseAction<Topic>){
    final nextCarouselTopicState = baseReducer(state.carouselTopicState, action);

    return state.copyWith(carouselTopicState: nextCarouselTopicState);
  }
  return state;
}

@immutable
class AppState{
  final BaseState<Topic> carouselTopicState;

  AppState({
    required this.carouselTopicState
  });

  AppState copyWith({
    BaseState<Topic>? carouselTopicState
  }){
    return AppState(
      carouselTopicState: carouselTopicState?? this.carouselTopicState
    );
  }
}


class ReduxStore{
  static Store<AppState> store() {
    final carouselTopicInitialState = BaseState<Topic>.initial();


    return Store<AppState>(
        appReducer,
        middleware: [thunkMiddleware],
        initialState: AppState(
          carouselTopicState: carouselTopicInitialState
        )
    );
  }
}

Store<AppState> appStore = ReduxStore.store();
