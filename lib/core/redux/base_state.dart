import 'package:flutter/material.dart';


typedef ItemCreator<Model> = Model Function();

@immutable
class BaseState<Modal, AcType>{
  final bool loading, loaded;
  final String error;
  final List<Modal>? theList;
  final Modal? theObject;

  BaseState({
    this.loading = false,
    this.loaded = false,
    this.error = '',
    this.theList,
    this.theObject
  });

  factory BaseState.initial(Modal Function() creator, {String dataType = 'list'}){
    BaseState<Modal, AcType> listState;
    if(dataType=='object'){
      listState = new BaseState(theObject: creator());
    }else{
      listState = BaseState(theList: <Modal>[]);
    }
    return listState;
  }

  Modal modelInstance(Modal Function() creator){
    final model = creator();
    return model;
  }

  BaseState<Modal, AcType> copyWith({
    bool? loading,
    bool? loaded,
    String? error,
    List<Modal>? theList,
    Modal? theObject
  }){
    return BaseState(
      loading: loading?? this.loading,
      loaded: loaded?? this.loaded,
      error: error?? this.error,
      theList: theList?? this.theList,
      theObject: theObject?? this.theObject
    );
  }
}