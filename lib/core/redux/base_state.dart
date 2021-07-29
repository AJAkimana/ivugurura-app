import 'package:flutter/material.dart';

@immutable
class BaseState<Modal>{
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

  factory BaseState.initial({String dataType = 'list'}){
    BaseState<Modal> listState = BaseState(theList: <Modal>[]) ;
    if(dataType=='object'){
      listState = BaseState(theObject: listState.theObject);
    }
    return listState;
  }

  BaseState<Modal> copyWith({
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