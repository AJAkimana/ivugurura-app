import 'package:flutter/cupertino.dart';
import 'package:ivugurura_app/core/redux/states.dart';
import 'package:redux/redux.dart';

@immutable
class TopicsActions{
  final TopicsState? topicsState;

  TopicsActions(TopicsState topicsState, {this.topicsState});
}

Future<void> fetchTopics(Store<AppState> store) async {
  try{

  } catch (error){
    store.dispatch(TopicsActions(TopicsState(isLoading: false, errorMessage: '')));
  }
}