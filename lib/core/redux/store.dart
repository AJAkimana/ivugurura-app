import 'package:flutter/cupertino.dart';
import 'package:ivugurura_app/core/redux/actions.dart';
import 'package:ivugurura_app/core/redux/reducers/topics_reducer.dart';
import 'package:ivugurura_app/core/redux/states.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

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
        topicsState: topicsState??this.topicsState
    );
  }
}


class AppStore{
  static Store<AppState> _store = Store<AppState>(
      appReducer,
      middleware: [],
      initialState:AppState(topicsState: TopicsState.initial())
  );

  static Store<AppState> get store{
    return _store;
  }

  static Future<void> init() async {
    final topicsInitialState = TopicsState.initial();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(topicsState: topicsInitialState)
    );
  }
}