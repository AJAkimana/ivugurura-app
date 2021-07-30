import 'package:ivugurura_app/core/redux/base_action.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';

baseReducer(BaseState<dynamic, dynamic> prevState, BaseAction<dynamic, dynamic> action){
  final payload = action.state;
  return prevState.copyWith(
    loading: payload.loading,
    loaded: payload.loaded,
    error: payload.error,
    theList: payload.theList,
    theObject: payload.theObject
  );
}