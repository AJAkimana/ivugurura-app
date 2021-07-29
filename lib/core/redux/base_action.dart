import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';

@immutable
class BaseAction<Modal>{
  final BaseState<Modal> state;

  BaseAction(BaseState<Modal> state) : state = state;
}

class DispatchedAction<Modal>{
  final String actionKey;
  late dynamic actionValue;

  DispatchedAction({
    this.actionKey = 'pending',
    this.actionValue = true
  });
  void setActionValue(dynamic newValue){
    this.actionValue = newValue;
  }
  pending(){
    return BaseAction<Modal>(BaseState<Modal>(loading: true));
  }
  fulfilled({dataType = 'list'}){
    dynamic data = BaseAction<Modal>(BaseState<Modal>(loading: false, loaded: true, theList: this.actionValue));
    if(dataType=='object'){
      data = BaseAction<Modal>(BaseState<Modal>(loading: false, loaded: true, theObject: this.actionValue));
    }
    return data;
  }
  rejected(){
    return BaseAction<Modal>(BaseState<Modal>(loading: false, error: this.actionValue));
  }
}
