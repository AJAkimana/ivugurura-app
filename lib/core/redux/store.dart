import 'package:flutter/cupertino.dart';
import 'package:ivugurura_app/core/redux/reducers/topics_reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'actions/topic_actions.dart';
import 'states/topics_states.dart';

AppState appReducer(AppState state, dynamic action){
  if(action is TopicsActions){
    final nextTopicsState = topicsReducer(state.topicsState, action);

    return state.copyWith(topicsState: nextTopicsState);
  }
  return state;
}

@immutable
class AppState{
  final TopicsState topicsState;

  AppState({
    required this.topicsState
  });

  AppState copyWith({
    TopicsState? topicsState,
  }){
    return AppState(
        topicsState: topicsState?? this.topicsState
    );
  }
}


class ReduxStore{
  static Store<AppState> store() {
    final topicsInitialState = TopicsState.initial();

    return Store<AppState>(
        appReducer,
        middleware: [thunkMiddleware],
        initialState: AppState(topicsState: topicsInitialState)
    );
  }
}

Store<AppState> appStore = ReduxStore.store();
