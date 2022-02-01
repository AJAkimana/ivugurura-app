import 'package:ivugurura_app/core/models/audio.dart';

import '../base_action.dart';
import '../store.dart';

void setCurrentAudio(Audio _audio) {
  final dispatchedAction = DispatchedAction<Audio, AudioDetail>();

  appStore.dispatch(dispatchedAction.fulfilled(_audio, dataType: 'object'));
}
