import 'package:ivugurura_app/core/models/audio.dart';

import '../base_action.dart';
import '../store.dart';

void setCurrentAudio(Audio _audio) {
  try {
    final dispatchedAction = DispatchedAction<Audio, AudioDetail>();
    // appStore.dispatch(dispatchedAction.pending());
    appStore.dispatch(dispatchedAction.fulfilled(_audio, dataType: 'object'));
  } catch (error) {
    print(error);
    // print('=================>${dispatchedAction.runtimeType}');
  }
}
