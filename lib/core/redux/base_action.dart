import 'package:flutter/material.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';

@immutable
class BaseAction<Modal, AcType>{
  final BaseState<Modal, AcType> state;

  BaseAction(BaseState<Modal, AcType> state) : state = state;
}

class DispatchedAction<Modal, AcType>{
  late dynamic actionValue;

  DispatchedAction({
    this.actionValue = true
  });
  void setActionValue(dynamic newValue){
    this.actionValue = newValue;
  }
  pending(){
    return BaseAction<Modal, AcType>(BaseState<Modal, AcType>(loading: true));
  }
  fulfilled(dynamic newValue, {dataType = 'list'}){
    this.actionValue = newValue;
    dynamic data = BaseAction<Modal, AcType>(
        BaseState<Modal, AcType>(
            loading: false,
            loaded: true,
            theList: this.actionValue
        )
    );
    if(dataType=='object'){
      data = BaseAction<Modal, AcType>(
          BaseState<Modal, AcType>(
              loading: false,
              loaded: true,
              theObject: this.actionValue
          )
      );
    }
    return data;
  }
  rejected(dynamic errorMessage){
    this.actionValue = errorMessage;
    return BaseAction<Modal, AcType>(
        BaseState<Modal, AcType>(
            loading: false,
            error: this.actionValue
        )
    );
  }
}
