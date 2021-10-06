import 'package:ivugurura_app/core/models/audio.dart';

class InMemoryStore{
  late dynamic _category;
  Audio _audio = Audio();

  Future<void> addCategory(dynamic category){
    return Future.microtask(() => _category = category);
  }

  Future<dynamic> getCategory(){
    return Future.microtask(() => _category);
  }

  void addAudio(Audio audio){
     _audio = audio;
  }

  Audio getAudio(){
    return  _audio;
  }
}